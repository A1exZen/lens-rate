import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/currencies.dart';
import '../../data/rates_providers.dart';
import '../../domain/entities/currency.dart';
import '../../l10n/app_localizations.dart';
import '../currency_selector/currency_selector_sheet.dart';
import '../converter/converter_provider.dart';
import 'live_scan_provider.dart';
import 'locale_provider.dart';
import 'theme_mode_provider.dart';

/// Settings screen (docs §4.4 / §15.3). Sections:
/// Appearance · Language · Default currencies · Exchange Rates · About
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final converterState = ref.watch(converterProvider);
    final ratesAsync = ref.watch(ratesProvider);

    final fromCurrency = Currencies.find(converterState.from);
    final toCurrency = Currencies.find(converterState.to);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          // ── Appearance ───────────────────────────────────────────────
          _SectionHeader(l.appearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _ThemeToggle(current: themeMode),
          ),

          // ── Language ─────────────────────────────────────────────────
          _SectionHeader(l.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _LanguageToggle(current: locale.languageCode),
          ),

          // ── Camera ───────────────────────────────────────────────────
          _SectionHeader(l.camera),
          SwitchListTile(
            secondary: const Icon(Icons.videocam_outlined),
            title: Text(l.liveScan),
            subtitle: Text(l.liveScanHint, style: AppTextStyles.caption),
            value: ref.watch(liveScanEnabledProvider),
            onChanged: (v) =>
                ref.read(liveScanEnabledProvider.notifier).set(v),
          ),

          // ── Default currencies ───────────────────────────────────────
          _SectionHeader(l.defaultCurrencies),
          _CurrencyTile(
            currency: fromCurrency,
            label: l.convertFrom,
            onPick: (code) async {
              ref.read(converterProvider.notifier).setFrom(code);
              await ref.read(prefsStorageProvider).setDefaultFrom(code);
            },
          ),
          _CurrencyTile(
            currency: toCurrency,
            label: l.convertTo,
            onPick: (code) async {
              ref.read(converterProvider.notifier).setTo(code);
              await ref.read(prefsStorageProvider).setDefaultTo(code);
            },
          ),

          // ── Exchange Rates ───────────────────────────────────────────
          _SectionHeader(l.exchangeRates),
          ratesAsync.when(
            loading: () => ListTile(
              leading: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              title: Text(l.loadingRates),
            ),
            error: (e, _) => ListTile(
              leading: const Icon(Icons.error_outline, color: AppColors.error),
              title: Text(l.failedRates),
              subtitle: Text(e.toString(), style: AppTextStyles.caption),
            ),
            data: (rates) {
              final age = rates.age;
              final ageText = age.inMinutes < 60
                  ? l.updatedMinutes(age.inMinutes)
                  : l.updatedHours(age.inHours);
              return ListTile(
                leading: Icon(
                  Icons.update,
                  color: age.inHours >= 1 ? AppColors.warning : AppColors.primary,
                ),
                title: Text(ageText),
                subtitle: Text(l.baseLabel(rates.base),
                    style: AppTextStyles.caption),
                trailing: TextButton(
                  onPressed: () => ref.read(ratesProvider.notifier).refresh(),
                  child: Text(l.refresh),
                ),
              );
            },
          ),

          // ── About ────────────────────────────────────────────────────
          _SectionHeader(l.about),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('LensRate'),
            subtitle: Text('v1.0.0', style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.label,
    required this.onPick,
  });

  final Currency? currency;
  final String label;
  final Future<void> Function(String code) onPick;

  @override
  Widget build(BuildContext context) {
    final c = currency;
    return ListTile(
      leading: c != null
          ? Text(c.flag, style: const TextStyle(fontSize: 24))
          : const Icon(Icons.monetization_on_outlined),
      title: Text(label),
      subtitle: c != null
          ? Text('${c.code} · ${c.name}', style: AppTextStyles.caption)
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final code = await CurrencySelectorSheet.show(context);
        if (code != null) await onPick(code);
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelMd.copyWith(color: AppColors.slate400),
      ),
    );
  }
}

/// Segmented control for Light / Dark / System theme (docs §15.3).
class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle({required this.current});
  final ThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          icon: const Icon(Icons.light_mode_outlined),
          label: Text(l.themeLight),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: const Icon(Icons.dark_mode_outlined),
          label: Text(l.themeDark),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: const Icon(Icons.phone_android_outlined),
          label: Text(l.themeSystem),
        ),
      ],
      selected: {current},
      onSelectionChanged: (selection) =>
          ref.read(appThemeModeProvider.notifier).set(selection.first),
    );
  }
}

/// Segmented control for the UI language (English / Русский).
class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle({required this.current});
  final String current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'en', label: Text('English')),
        ButtonSegment(value: 'ru', label: Text('Русский')),
      ],
      selected: {current},
      onSelectionChanged: (selection) =>
          ref.read(appLocaleProvider.notifier).set(selection.first),
    );
  }
}
