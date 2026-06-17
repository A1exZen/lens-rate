import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/currency.dart';
import '../../../l10n/app_localizations.dart';

/// Currency pill for the camera top bar (docs §14.2 / §15.1): flag + ISO code +
/// chevron on a dark translucent background, readable over any scene.
class CurrencyChip extends StatelessWidget {
  const CurrencyChip({required this.currency, required this.onTap, super.key});

  final Currency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppL10n.of(context).changeCurrencyHint(currency.name),
      child: Material(
        color: AppColors.overlayBgLight,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currency.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.s2),
                Text(
                  currency.code,
                  style: AppTextStyles.titleMd.copyWith(color: AppColors.white),
                ),
                const Icon(Icons.expand_more, size: 16, color: AppColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
