import 'dart:io';
import 'dart:ui' as ui;

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
import 'detected_price.dart';
import 'price_scanner.dart';
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
      final controller = CameraController(
        back,
        // Higher resolution → sharper text → noticeably better OCR (docs §6.3).
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _status = _Status.ready;
      });
    } catch (_) {
      // Any failure (missing plugin, no camera, denied hardware) → error state,
      // never leave the spinner running forever.
      if (mounted) setState(() => _status = _Status.error);
    }
  }

  Future<void> _scan() async {
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
      final size = await _decodeSize(file.path);
      final detections = await _scanner.scan(file.path);
      final prices = _convert(detections);

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

  Future<Size> _decodeSize(String path) async {
    final bytes = await File(path).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    var w = frame.image.width.toDouble();
    var h = frame.image.height.toDouble();

    // ML Kit fromFilePath() applies EXIF and returns boxes in display-space.
    // Image.file also applies EXIF. But on some Android builds
    // instantiateImageCodec returns raw sensor dims (landscape: w > h) without
    // respecting EXIF. Guard: if sensor is rotated 90/270° and codec gave us a
    // landscape image, swap so all three coordinate spaces agree.
    final sensorOrientation = _controller!.description.sensorOrientation;
    if ((sensorOrientation == 90 || sensorOrientation == 270) && w > h) {
      final tmp = w;
      w = h;
      h = tmp;
    }
    return Size(w, h);
  }

  /// Converts each detection into the target currency. The source is the
  /// currency detected on the tag, or the user-selected "From" when none was.
  List<DetectedPrice> _convert(List<RawDetection> detections) {
    final rates = ref.read(ratesProvider).value;
    final state = ref.read(converterProvider);
    if (rates == null) return const [];

    // Rank the most price-like first: an explicit currency cue, then a decimal
    // part, then the larger amount. PriceOverlay shows the top few.
    final ranked = [...detections]..sort((a, b) {
        final cue = (b.currencyCode != null ? 1 : 0)
            .compareTo(a.currencyCode != null ? 1 : 0);
        if (cue != 0) return cue;
        final dec = (b.hasDecimal ? 1 : 0).compareTo(a.hasDecimal ? 1 : 0);
        if (dec != 0) return dec;
        return b.amount.compareTo(a.amount);
      });

    final prices = <DetectedPrice>[];
    for (final d in ranked) {
      final source = d.currencyCode ?? state.from;
      if (source == state.to) continue; // nothing to convert
      final rate = rates.getRate(from: source, to: state.to);
      if (rate == 0) continue; // unknown currency — skip rather than show 0
      prices.add(DetectedPrice(
        rect: d.rect,
        originalAmount: d.amount,
        sourceCurrency: source,
        convertedAmount: d.amount * rate,
        targetCurrency: state.to,
      ));
    }
    return prices;
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
    if (!_isFrozen) return;
    setState(() => _prices = _convert(_detections));
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
