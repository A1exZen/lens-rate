// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get scan => 'Scan';

  @override
  String get settings => 'Settings';

  @override
  String get amountHint => '0';

  @override
  String get ratesLoadError => 'Couldn’t load rates. Check your connection.';

  @override
  String offlineFrom(String date) {
    return 'Offline — showing rates from $date';
  }

  @override
  String rateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get updatedJustNow => 'Updated just now';

  @override
  String updatedMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return 'Updated $_temp0';
  }

  @override
  String updatedHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count h ago',
      one: '1 h ago',
    );
    return 'Updated $_temp0';
  }

  @override
  String updatedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count d ago',
      one: '1 d ago',
    );
    return 'Updated $_temp0';
  }

  @override
  String get searchCurrency => 'Search currency';

  @override
  String get popular => 'Popular';

  @override
  String get recent => 'Recent';

  @override
  String get allCurrencies => 'All currencies';

  @override
  String changeCurrencyHint(String name) {
    return 'Currency $name, tap to change';
  }

  @override
  String get swapCurrencies => 'Swap currencies';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get defaultCurrencies => 'Default currencies';

  @override
  String get convertFrom => 'Convert from';

  @override
  String get convertTo => 'Convert to';

  @override
  String get exchangeRates => 'Exchange Rates';

  @override
  String get loadingRates => 'Loading rates…';

  @override
  String get failedRates => 'Failed to load rates';

  @override
  String get refresh => 'Refresh';

  @override
  String baseLabel(String code) {
    return 'Base: $code';
  }

  @override
  String get about => 'About';

  @override
  String get cameraAccessTitle => 'Camera access needed';

  @override
  String get cameraAccessBody =>
      'LensRate reads price tags through the camera and shows the converted price on top. Enable camera access to start scanning.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get cameraUnavailable => 'Camera unavailable';

  @override
  String get noPricesFound =>
      'No prices found — aim at a price tag and tap scan again';

  @override
  String get fromTag => 'From (tag)';

  @override
  String get toYours => 'To (yours)';

  @override
  String get torch => 'Torch';

  @override
  String get convert => 'Convert';

  @override
  String get back => 'Back';

  @override
  String get scanPrices => 'Scan prices';

  @override
  String get scanAgain => 'Scan again';
}
