import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/currencies.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/rates_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/offline_banner.dart';
import '../../shared/widgets/rate_info_line.dart';
import '../currency_selector/currency_selector_sheet.dart';
import 'converter_provider.dart';
import 'widgets/currency_row.dart';
import 'widgets/swap_button.dart';

/// Manual converter (docs §4.2 / §15.2): live conversion as you type, no confirm
/// button. Plain background, no cards.
class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency({required bool isFrom}) async {
    final code = await CurrencySelectorSheet.show(context);
    if (code == null) return;
    final notifier = ref.read(converterProvider.notifier);
    isFrom ? notifier.setFrom(code) : notifier.setTo(code);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(converterProvider);
    final from = Currencies.find(state.from)!;
    final to = Currencies.find(state.to)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LensRate', style: AppTextStyles.displayMd),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppL10n.of(context).settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/camera'),
        icon: const Icon(Icons.center_focus_strong),
        label: Text(AppL10n.of(context).scan),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: AppSpacing.screenPadding.copyWith(bottom: 96),
          children: [
            const SizedBox(height: AppSpacing.s4),
            _AmountInput(controller: _amountController),
            const SizedBox(height: AppSpacing.s6),
            CurrencyRow(currency: from, onTap: () => _pickCurrency(isFrom: true)),
            Center(
              child: SwapButton(
                onPressed: ref.read(converterProvider.notifier).swapCurrencies,
              ),
            ),
            CurrencyRow(currency: to, onTap: () => _pickCurrency(isFrom: false)),
            const SizedBox(height: AppSpacing.s8),
            const _ResultSection(),
          ],
        ),
      ),
    );
  }
}

/// Large numeric input — the hero of the screen (docs §15.2, display-xl 40sp).
class _AmountInput extends ConsumerWidget {
  const _AmountInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      autofocus: false,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.displayXl,
      cursorColor: AppColors.primary,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '0',
      ),
      onChanged: ref.read(converterProvider.notifier).setAmount,
    );
  }
}

/// Live result + rate line + offline/error states (docs §15.2, §18).
class _ResultSection extends ConsumerWidget {
  const _ResultSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(converterProvider);
    final ratesAsync = ref.watch(ratesProvider);
    final conv = ref.watch(conversionProvider);

    return ratesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => Text(
        AppL10n.of(context).ratesLoadError,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.error),
      ),
      data: (rates) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rates.age >= const Duration(hours: 1))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s4),
              child: OfflineBanner(cachedAt: rates.fetchedAt),
            ),
          Semantics(
            label: 'Result: approximately '
                '${CurrencyFormatter.formatWithCode(conv.result, state.to)}',
            child: Text(
              CurrencyFormatter.formatConverted(conv.result, state.to),
              style: AppTextStyles.displayXl.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          RateInfoLine(
            from: state.from,
            to: state.to,
            rate: conv.rate,
            rates: rates,
            onRefresh: () => ref.read(ratesProvider.notifier).refresh(),
          ),
        ],
      ),
    );
  }
}
