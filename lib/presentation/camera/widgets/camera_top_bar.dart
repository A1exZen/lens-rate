import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/currency.dart';
import '../../../l10n/app_localizations.dart';
import 'currency_chip.dart';

/// Top bar over the camera (docs §15.1 Layer 2): the source (auto-detected or
/// chosen) and target currency, with a swap between them. Labels make the
/// direction unambiguous.
class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    required this.from,
    required this.to,
    required this.onTapFrom,
    required this.onTapTo,
    required this.onSwap,
    super.key,
  });

  final Currency from;
  final Currency to;
  final VoidCallback onTapFrom;
  final VoidCallback onTapTo;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.overlayBgLight, Colors.transparent],
        ),
      ),
      child: Builder(
        builder: (context) {
          final l = AppL10n.of(context);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LabeledChip(label: l.fromTag, currency: from, onTap: onTapFrom),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  onPressed: onSwap,
                  icon: const Icon(Icons.swap_horiz, color: AppColors.white),
                  tooltip: l.swapCurrencies,
                ),
              ),
              _LabeledChip(label: l.toYours, currency: to, onTap: onTapTo),
            ],
          );
        },
      ),
    );
  }
}

class _LabeledChip extends StatelessWidget {
  const _LabeledChip({
    required this.label,
    required this.currency,
    required this.onTap,
  });

  final String label;
  final Currency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 4),
        CurrencyChip(currency: currency, onTap: onTap),
      ],
    );
  }
}
