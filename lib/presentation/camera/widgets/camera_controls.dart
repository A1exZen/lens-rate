import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom control bar over the camera (docs §15.1 Layer 3): torch toggle,
/// scan / rescan, and a shortcut to the manual converter.
class CameraControls extends StatelessWidget {
  const CameraControls({
    required this.torchOn,
    required this.isFrozen,
    required this.onToggleTorch,
    required this.onScan,
    required this.onOpenConverter,
    this.showScan = true,
    super.key,
  });

  final bool torchOn;
  final bool isFrozen;
  final bool showScan;
  final VoidCallback onToggleTorch;
  final VoidCallback onScan;
  final VoidCallback onOpenConverter;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Container(
      height: 88,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.overlayBgLight, Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconAction(
            icon: torchOn ? Icons.flash_on : Icons.flash_off,
            label: l.torch,
            active: torchOn,
            onTap: onToggleTorch,
          ),
          if (showScan)
            _ScanButton(
              isFrozen: isFrozen,
              label: isFrozen ? l.scanAgain : l.scanPrices,
              onTap: onScan,
            ),
          _IconAction(
            icon: Icons.calculate_outlined,
            label: l.convert,
            onTap: onOpenConverter,
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({
    required this.isFrozen,
    required this.label,
    required this.onTap,
  });

  final bool isFrozen;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: AppColors.white, width: 4),
          ),
          child: Icon(
            isFrozen ? Icons.refresh : Icons.center_focus_strong,
            color: AppColors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryOnDark : AppColors.white;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 2),
              Text(label,
                  style: AppTextStyles.micro.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
