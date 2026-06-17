import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/currency.dart';

/// A single currency row in the selector (docs §14.6): 56dp, flag + full name
/// + ISO code.
class CurrencyListTile extends StatelessWidget {
  const CurrencyListTile({
    required this.currency,
    required this.onTap,
    super.key,
  });

  final Currency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 0,
      leading: Text(currency.flag, style: const TextStyle(fontSize: 28)),
      title: Text(currency.name, style: AppTextStyles.bodyMd),
      trailing: Text(
        currency.code,
        style: AppTextStyles.labelMd.copyWith(color: AppColors.slate400),
      ),
    );
  }
}
