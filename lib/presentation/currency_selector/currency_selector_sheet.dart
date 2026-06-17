import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import 'currency_search_provider.dart';
import 'widgets/currency_list_tile.dart';

/// Bottom-sheet currency picker shared by both screens (docs §4.3 / §14.6).
/// Returns the chosen ISO code, or null if dismissed.
class CurrencySelectorSheet extends ConsumerStatefulWidget {
  const CurrencySelectorSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: 0.4), // scrim 40% (docs §14.6)
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (_) => const CurrencySelectorSheet(),
    );
  }

  @override
  ConsumerState<CurrencySelectorSheet> createState() =>
      _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState
    extends ConsumerState<CurrencySelectorSheet> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset any stale query from a previous open.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currencyQueryProvider.notifier).update('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _select(String code) {
    ref.read(recentCurrenciesProvider.notifier).add(code);
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final recents = ref.watch(recentCurrenciesProvider);
    final results = ref.watch(filteredCurrenciesProvider);
    final showRecents = _searchController.text.isEmpty && recents.isNotEmpty;

    // Sheet rises with the keyboard (docs §14.6 keyboard avoidance).
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Column(
          children: [
            const _Handle(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: _SearchField(controller: _searchController),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (showRecents) ...[
                    _SectionLabel(l.recent),
                    for (final c in recents)
                      CurrencyListTile(currency: c, onTap: () => _select(c.code)),
                    const Divider(height: AppSpacing.s6),
                    _SectionLabel(l.allCurrencies),
                  ],
                  for (final c in results)
                    CurrencyListTile(currency: c, onTap: () => _select(c.code)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 4,
      margin: const EdgeInsets.only(top: AppSpacing.s3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: AppL10n.of(context).searchCurrency,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        ref.read(currencyQueryProvider.notifier).update(value);
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s2,
        AppSpacing.s4,
        AppSpacing.s1,
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelMd.copyWith(color: AppColors.slate400),
      ),
    );
  }
}
