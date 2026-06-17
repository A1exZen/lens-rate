import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

/// Shown when camera access is denied (docs §4.1): explanation + a CTA that
/// deep-links to the system settings so the user can grant it.
class CameraPermissionView extends StatelessWidget {
  const CameraPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined,
                size: 64, color: AppColors.slate400),
            const SizedBox(height: AppSpacing.s6),
            Text(l.cameraAccessTitle,
                style: AppTextStyles.titleLg, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s3),
            Text(
              l.cameraAccessBody,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.slate600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s6),
            FilledButton.icon(
              onPressed: openAppSettings,
              icon: const Icon(Icons.settings),
              label: Text(l.openSettings),
            ),
          ],
        ),
      ),
    );
  }
}
