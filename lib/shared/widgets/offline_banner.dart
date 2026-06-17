import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

/// Slim banner shown when rates couldn't be refreshed and cached ones are in
/// use (docs §4.1, §6.4). Warning amber, with the cache date.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({required this.cachedAt, super.key});

  final DateTime cachedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warningLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 16, color: AppColors.warning),
          const SizedBox(width: AppSpacing.s2),
          Flexible(
            child: Text(
              AppL10n.of(context).offlineFrom(_date(cachedAt)),
              style: AppTextStyles.labelMd.copyWith(color: AppColors.slate900),
            ),
          ),
        ],
      ),
    );
  }

  String _date(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)} ${two(d.hour)}:${two(d.minute)}';
  }
}
