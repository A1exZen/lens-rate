import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/currency.dart';
import '../../../l10n/app_localizations.dart';
import '../detected_price.dart';
import 'camera_controls.dart';
import 'camera_top_bar.dart';
import 'price_overlay.dart';

/// Presentational camera layer stack (docs §15.1): preview/frozen still, AR
/// overlays, top bar, bottom controls, back button. All state and actions are
/// owned by CameraScreen and passed in.
class CameraView extends StatelessWidget {
  const CameraView({
    required this.controller,
    required this.isFrozen,
    required this.liveMode,
    required this.busy,
    required this.torchOn,
    required this.capturedPath,
    required this.imageSize,
    required this.prices,
    required this.from,
    required this.to,
    required this.onScan,
    required this.onToggleTorch,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
    required this.onOpenConverter,
    required this.onBack,
    super.key,
  });

  final CameraController controller;
  final bool isFrozen;
  final bool liveMode;
  final bool busy;
  final bool torchOn;
  final String? capturedPath;
  final Size? imageSize;
  final List<DetectedPrice> prices;
  final Currency from;
  final Currency to;
  final VoidCallback onScan;
  final VoidCallback onToggleTorch;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;
  final VoidCallback onOpenConverter;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 0: live preview or frozen still.
        if (isFrozen)
          Image.file(File(capturedPath!), fit: BoxFit.cover)
        else
          _PreviewCover(controller: controller),

        // Layer 1: AR price pills — over the frozen still (tap-to-scan) or over
        // the live preview (live scan). The "no prices" hint is tap-to-scan only.
        if ((isFrozen || liveMode) && imageSize != null)
          PriceOverlay(prices: prices, imageSize: imageSize!),
        if (isFrozen && !liveMode && prices.isEmpty) const _NoPricesHint(),

        // Layer 2: top bar with From ⇄ To chips.
        SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: CameraTopBar(
              from: from,
              to: to,
              onTapFrom: onPickFrom,
              onTapTo: onPickTo,
              onSwap: onSwap,
            ),
          ),
        ),

        // Layer 3: bottom controls.
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CameraControls(
                torchOn: torchOn,
                isFrozen: isFrozen,
                // Live mode scans continuously — no manual scan button.
                showScan: !liveMode,
                onToggleTorch: onToggleTorch,
                onScan: onScan,
                onOpenConverter: onOpenConverter,
              ),
            ),
          ),
        ),

        // Layer 4: back button (top-left).
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: AppColors.overlayBgLight,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  tooltip: AppL10n.of(context).back,
                  onPressed: onBack,
                ),
              ),
            ),
          ),
        ),

        if (busy)
          const Center(child: CircularProgressIndicator(color: AppColors.white)),
      ],
    );
  }
}

/// Fills the screen with the preview, cropping via cover (docs §15.1).
class _PreviewCover extends StatelessWidget {
  const _PreviewCover({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var scale = size.aspectRatio * controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return ClipRect(
      child: Transform.scale(
        scale: scale,
        child: Center(child: CameraPreview(controller)),
      ),
    );
  }
}

class _NoPricesHint extends StatelessWidget {
  const _NoPricesHint();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.overlayBgLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          AppL10n.of(context).noPricesFound,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
