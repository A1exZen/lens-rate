import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/exchange_rates.dart';
import '../../l10n/app_localizations.dart';

/// Trust signal showing the unit rate and how fresh it is (docs §14.4):
/// fresh (<1h) muted · stale (1–12h) amber · very stale (>12h) red.
class RateInfoLine extends StatelessWidget {
  const RateInfoLine({
    required this.from,
    required this.to,
    required this.rate,
    required this.rates,
    this.onRefresh,
    super.key,
  });

  final String from;
  final String to;
  final double rate;
  final ExchangeRates rates;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final age = rates.age;
    final (color, icon) = _freshness(age);
    final rateText = l.rateLine(
      from.toUpperCase(),
      CurrencyFormatter.formatAmount(rate, to),
      to.toUpperCase(),
    );
    final updated = _updated(l, age);

    return Semantics(
      button: onRefresh != null,
      label: '$rateText. $updated.',
      child: InkWell(
        onTap: onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  '$rateText · $updated',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, IconData?) _freshness(Duration age) {
    if (age < const Duration(hours: 1)) return (AppColors.slate400, null);
    if (age < const Duration(hours: 12)) {
      return (AppColors.warning, Icons.warning_amber_rounded);
    }
    return (AppColors.error, Icons.error_outline);
  }

  String _updated(AppL10n l, Duration age) {
    if (age.inMinutes < 1) return l.updatedJustNow;
    if (age.inMinutes < 60) return l.updatedMinutes(age.inMinutes);
    if (age.inHours < 24) return l.updatedHours(age.inHours);
    return l.updatedDays(age.inDays);
  }
}
