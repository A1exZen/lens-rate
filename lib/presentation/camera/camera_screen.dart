import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/currencies.dart';
import '../../data/rates_providers.dart';
import '../../l10n/app_localizations.dart';
import '../converter/converter_provider.dart';
import '../currency_selector/currency_selector_sheet.dart';
import '../settings/live_scan_provider.dart';
import 'detected_price.dart';
import 'live_frame_converter.dart';
import 'live_stabilizer.dart';
import 'price_converter.dart';
import 'price_scanner.dart';
import 'still_image_size.dart';
import 'widgets/camera_permission_view.dart';
import 'widgets/camera_view.dart';

enum _Status { initializing, ready, denied, error }

/// Camera / AR mode (docs §4.1, §15.1). Tap-to-scan: point → tap → the still is
/// frozen, OCR'd, and converted prices float over the detected tags (docs §6.3).
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  final PriceScanner _scanner = PriceScanner();
  CameraController? _controller;
  _Status _status = _Status.initializing;
  bool _torchOn = false;
  bool _busy = false;

  // Live-scan state: when on, frames stream through OCR continuously.
  bool _live = false;
  bool _processing = false;
  DateTime _lastFrame = DateTime.fromMillisecondsSinceEpoch(0);

  // Scan no more often than this; temporal smoothing/locking lives in the
  // stabilizer so a single central price stays put instead of flipping between
  // per-frame OCR misreads (docs §6.3).
  static const _liveThrottle = Duration(milliseconds: 700);
  final LiveStabilizer _stabilizer = LiveStabilizer();

  // Frozen-frame state (null = live preview).
  String? _capturedPath;
  Size? _imageSize;
  List<RawDetection> _detections = const [];
  List<DetectedPrice> _prices = const [];

  bool get _isFrozen => _capturedPath != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Immersive full-screen: hide the status/navigation bars so the preview is
    // truly edge-to-edge (no top/bottom system cut-outs) — docs §15.1.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _setup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    _scanner.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    // Free the camera when backgrounded, re-acquire on resume (plugin rule).
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setup();
    }
  }

  Future<void> _setup() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) setState(() => _status = _Status.denied);
        return;
      }
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final live = ref.read(liveScanEnabledProvider);
      final controller = CameraController(
        back,
        // Live streams every frame → a lighter preset keeps OCR real-time;
        // tap-to-scan affords veryHigh for the sharpest single still (docs §6.3).
        live ? ResolutionPreset.high : ResolutionPreset.veryHigh,
        enableAudio: false,
        // Single-plane formats ML Kit can read directly from a stream.
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _status = _Status.ready;
        _live = live;
      });
      if (live) {
        _stabilizer.reset();
        await controller.startImageStream(_onFrame);
      }
    } catch (_) {
      // Any failure (missing plugin, no camera, denied hardware) → error state,
      // never leave the spinner running forever.
      if (mounted) setState(() => _status = _Status.error);
    }
  }

  Future<void> _scan() async {
    if (_live) return; // live mode scans continuously — no manual capture
    if (_isFrozen) {
      setState(() {
        _capturedPath = null;
        _prices = const [];
        _detections = const [];
      });
      return;
    }
    final controller = _controller;
    if (controller == null || _busy) return;

    setState(() => _busy = true);
    try {
      final file = await controller.takePicture();
      final size = await decodeUprightStillSize(
          file.path, controller.description.sensorOrientation);
      final detections = await _scanner.scan(file.path);
      final prices = _convert(detections, size);

      if (prices.isNotEmpty) HapticFeedback.lightImpact();
      if (!mounted) return;
      setState(() {
        _capturedPath = file.path;
        _imageSize = size;
        _detections = detections;
        _prices = prices;
      });
    } on CameraException {
      // Capture failed — stay live; the user can retry.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Ranks + converts detections (delegates to [convertDetections]). Source is
  /// the currency detected on the tag, or the selected "From" when none was.
  List<DetectedPrice> _convert(List<RawDetection> detections, Size imageSize) {
    final rates = ref.read(ratesProvider).value;
    final state = ref.read(converterProvider);
    if (rates == null) return const [];
    return convertDetections(
      detections: detections,
      imageSize: imageSize,
      rates: rates,
      from: state.from,
      to: state.to,
    );
  }

  /// Live scanning: throttled OCR on streamed frames, overlaying prices on the
  /// live preview without freezing (docs §6.3 P1). Drops frames while one is in
  /// flight and rate-limits to keep the preview smooth.
  Future<void> _onFrame(CameraImage image) async {
    if (_processing) return;
    if (DateTime.now().difference(_lastFrame) < _liveThrottle) return;
    _processing = true;
    try {
      final controller = _controller;
      if (controller == null) return;
      final frame = buildLiveFrame(image, controller, controller.description);
      if (frame == null) return;
      final detections = await _scanner.scanInput(frame.input);
      final prices = _convert(detections, frame.uprightSize);
      if (!mounted) return;

      // Smoothing/locking decides what (if anything) to show — see LiveStabilizer.
      if (_stabilizer.update(prices, DateTime.now())) {
        setState(() {
          _imageSize = frame.uprightSize;
          _detections = detections;
          _prices = _stabilizer.shown;
        });
      }
    } catch (_) {
      // Skip an unprocessable frame; the next one will try again.
    } finally {
      _lastFrame = DateTime.now();
      _processing = false;
    }
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null) return;
    final next = !_torchOn;
    await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    if (mounted) setState(() => _torchOn = next);
  }

  Future<void> _pickCurrency({required bool isFrom}) async {
    final code = await CurrencySelectorSheet.show(context);
    if (code == null) return;
    final notifier = ref.read(converterProvider.notifier);
    final prefs = ref.read(prefsStorageProvider);
    if (isFrom) {
      notifier.setFrom(code);
      await prefs.setDefaultFrom(code);
    } else {
      notifier.setTo(code);
      await prefs.setDefaultTo(code);
    }
    _rescore();
  }

  /// Re-run the conversion on the frozen frame after a currency change, so the
  /// overlays update without needing another capture.
  void _rescore() {
    if (!_isFrozen || _imageSize == null) return;
    setState(() => _prices = _convert(_detections, _imageSize!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (_status) {
        _Status.denied => const CameraPermissionView(),
        _Status.error => Center(
            child: Text(AppL10n.of(context).cameraUnavailable,
                style: const TextStyle(color: AppColors.white))),
        _Status.initializing => const Center(
            child: CircularProgressIndicator(color: AppColors.white)),
        _Status.ready => _buildCamera(),
      },
    );
  }

  Widget _buildCamera() {
    final state = ref.watch(converterProvider);
    return CameraView(
      controller: _controller!,
      isFrozen: _isFrozen,
      liveMode: _live,
      busy: _busy,
      torchOn: _torchOn,
      capturedPath: _capturedPath,
      imageSize: _imageSize,
      prices: _prices,
      from: Currencies.find(state.from)!,
      to: Currencies.find(state.to)!,
      onScan: _scan,
      onToggleTorch: _toggleTorch,
      onPickFrom: () => _pickCurrency(isFrom: true),
      onPickTo: () => _pickCurrency(isFrom: false),
      onSwap: () {
        ref.read(converterProvider.notifier).swapCurrencies();
        _rescore();
      },
      onOpenConverter: _goBack,
      onBack: _goBack,
    );
  }

  void _goBack() =>
      context.canPop() ? context.pop() : context.go('/converter');
}
