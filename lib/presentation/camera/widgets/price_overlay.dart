import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../detected_price.dart';

/// Lays out converted-price pills over the frozen capture (docs §14.1).
///
/// ML Kit reports bounding boxes in image-pixel coordinates, but the still is
/// shown with BoxFit.cover. We replicate that transform (scale + centre offset)
/// to place each pill on the right spot. Caps at 3 to avoid clutter (docs §14.1).
class PriceOverlay extends StatelessWidget {
  const PriceOverlay({
    required this.prices,
    required this.imageSize,
    super.key,
  });

  final List<DetectedPrice> prices;
  final Size imageSize;

  static const _pillW = 150.0; // nominal width used for anchoring/centring
  static const _maxPillW = 230.0; // pill may stretch up to here for big numbers
  static const _pillH = 64.0;
  static const _gap = 6.0;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final view = constraints.biggest;
        // BoxFit.cover: scale = max of the two axis ratios.
        final coverScale =
            view.width / imageSize.width > view.height / imageSize.height
                ? view.width / imageSize.width
                : view.height / imageSize.height;
        final dx = (view.width - imageSize.width * coverScale) / 2;
        final dy = (view.height - imageSize.height * coverScale) / 2;
        Offset map(Offset p) =>
            Offset(p.dx * coverScale + dx, p.dy * coverScale + dy);

        // Usable band — keep pills clear of the top bar and bottom controls.
        final bandTop = padding.top + 96;
        final bandBottom =
            (view.height - padding.bottom - 132 - _pillH).clamp(bandTop, double.infinity);
        // Clamp against the max width so even a stretched pill stays on-screen.
        final maxLeft = (view.width - _maxPillW - 8).clamp(8.0, double.infinity);

        final placed = <Rect>[];
        final widgets = <Widget>[];
        for (final price in prices.take(3)) {
          final box = Rect.fromLTRB(
            map(price.rect.topLeft).dx,
            map(price.rect.topLeft).dy,
            map(price.rect.bottomRight).dx,
            map(price.rect.bottomRight).dy,
          );
          final left = (box.center.dx - _pillW / 2).clamp(8.0, maxLeft).toDouble();
          // Prefer above the tag, else below; then clamp into the band.
          var top = box.top - _pillH - _gap;
          if (top < bandTop) top = box.bottom + _gap;
          top = top.clamp(bandTop, bandBottom).toDouble();
          top = _avoidOverlap(left, top, placed);

          placed.add(Rect.fromLTWH(left, top, _maxPillW, _pillH));
          widgets.add(Positioned(
            left: left,
            top: top,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _pillW,
                maxWidth: _maxPillW,
              ),
              child: _PricePill(price: price),
            ),
          ));
        }
        return Stack(children: widgets);
      },
    );
  }

  /// Nudges a pill down past any already-placed pill it would overlap.
  double _avoidOverlap(double left, double top, List<Rect> placed) {
    var y = top;
    for (final r in placed) {
      final overlapsX = (left - r.left).abs() < _pillW;
      final overlapsY = y < r.bottom + _gap && y + _pillH + _gap > r.top;
      if (overlapsX && overlapsY) y = r.bottom + _gap;
    }
    return y;
  }
}

/// The floating pill: original price (small, muted) above, converted amount
/// (large, white) below, with the target currency code in brand green (§14.1).
class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});

  final DetectedPrice price;

  @override
  Widget build(BuildContext context) {
    // Reduce Motion: fade only, no scale (docs §17.4).
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: reduceMotion
            ? child
            : Transform.scale(scale: 0.92 + 0.08 * t, child: child),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s2,
        ),
        decoration: BoxDecoration(
          color: AppColors.overlayBgLight,
          borderRadius: BorderRadius.circular(AppRadius.overlay),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyFormatter.formatWithCode(
                  price.originalAmount, price.sourceCurrency),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMd.copyWith(color: AppColors.slate400),
            ),
            const SizedBox(height: 2),
            // Pill stretches to fit; if the number is still too big, the text
            // scales down (no ellipsis) so the full amount is always readable.
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    CurrencyFormatter.formatAmount(
                        price.convertedAmount, price.targetCurrency),
                    style: AppTextStyles.displayLg.copyWith(
                      color: AppColors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s1),
                  Text(
                    price.targetCurrency,
                    style: AppTextStyles.titleMd
                        .copyWith(color: AppColors.primaryOnDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
