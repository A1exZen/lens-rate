import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Circular swap button (docs §14.3): 44dp, bordered, primary icon that rotates
/// 180° with a spring overshoot on each tap. Medium haptic on press.
class SwapButton extends StatefulWidget {
  const SwapButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  // Spring overshoot curve (docs §14.3 cubic-bezier(0.34, 1.56, 0.64, 1)).
  late final Animation<double> _turns = Tween<double>(begin: 0, end: 0.5)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    // Respect Reduce Motion: instant icon swap, no rotation (docs §17.4).
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = _controller.value == 0 ? 0.5 : 0;
    } else {
      _controller.forward(from: 0);
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: AppL10n.of(context).swapCurrencies,
      child: SizedBox(
        width: AppSpacing.minTouchTarget,
        height: AppSpacing.minTouchTarget,
        child: Material(
          shape: CircleBorder(side: BorderSide(color: scheme.outline)),
          color: scheme.surfaceContainerHighest,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _handleTap,
            child: RotationTransition(
              turns: _turns,
              child: Icon(Icons.swap_vert, size: 20, color: scheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
