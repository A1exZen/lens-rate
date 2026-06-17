import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/currency.dart';
import '../../../l10n/app_localizations.dart';

/// A selectable currency row: flag + code + name + chevron (docs §15.2).
/// Tapping opens the currency selector to change it.
class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    required this.currency,
    required this.onTap,
    super.key,
  });

  final Currency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: AppL10n.of(context).changeCurrencyHint(currency.name),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.input),
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
            child: Row(
              children: [
                Text(currency.flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.s3),
                Text(currency.code, style: AppTextStyles.titleMd),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    currency.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd.copyWith(color: scheme.outline),
                  ),
                ),
                Icon(Icons.expand_more, color: scheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
