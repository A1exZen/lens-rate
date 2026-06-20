// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppL10nRu extends AppL10n {
  AppL10nRu([String locale = 'ru']) : super(locale);

  @override
  String get scan => 'Сканировать';

  @override
  String get settings => 'Настройки';

  @override
  String get amountHint => '0';

  @override
  String get ratesLoadError =>
      'Не удалось загрузить курсы. Проверьте соединение.';

  @override
  String offlineFrom(String date) {
    return 'Офлайн — курсы от $date';
  }

  @override
  String rateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get updatedJustNow => 'Обновлено только что';

  @override
  String updatedMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минуту',
    );
    return 'Обновлено $_temp0 назад';
  }

  @override
  String updatedHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      many: '$count часов',
      few: '$count часа',
      one: '$count час',
    );
    return 'Обновлено $_temp0 назад';
  }

  @override
  String updatedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return 'Обновлено $_temp0 назад';
  }

  @override
  String get searchCurrency => 'Поиск валюты';

  @override
  String get popular => 'Популярные';

  @override
  String get recent => 'Недавние';

  @override
  String get allCurrencies => 'Все валюты';

  @override
  String changeCurrencyHint(String name) {
    return 'Валюта $name, нажмите чтобы изменить';
  }

  @override
  String get swapCurrencies => 'Поменять валюты местами';

  @override
  String get appearance => 'Оформление';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get language => 'Язык';

  @override
  String get defaultCurrencies => 'Валюты по умолчанию';

  @override
  String get convertFrom => 'Из валюты';

  @override
  String get convertTo => 'В валюту';

  @override
  String get exchangeRates => 'Курсы валют';

  @override
  String get loadingRates => 'Загрузка курсов…';

  @override
  String get failedRates => 'Не удалось загрузить курсы';

  @override
  String get refresh => 'Обновить';

  @override
  String baseLabel(String code) {
    return 'База: $code';
  }

  @override
  String get about => 'О приложении';

  @override
  String get cameraAccessTitle => 'Нужен доступ к камере';

  @override
  String get cameraAccessBody =>
      'LensRate считывает ценники через камеру и показывает конвертированную цену поверх них. Разрешите доступ к камере, чтобы начать сканирование.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get cameraUnavailable => 'Камера недоступна';

  @override
  String get noPricesFound =>
      'Цены не найдены — наведите на ценник и сканируйте снова';

  @override
  String get fromTag => 'Из (ценник)';

  @override
  String get toYours => 'В (ваша)';

  @override
  String get torch => 'Фонарик';

  @override
  String get convert => 'Конвертер';

  @override
  String get back => 'Назад';

  @override
  String get scanPrices => 'Сканировать цены';

  @override
  String get scanAgain => 'Сканировать снова';

  @override
  String get camera => 'Камера';

  @override
  String get liveScan => 'Живое сканирование';

  @override
  String get liveScanHint =>
      'Распознавать цены непрерывно, без нажатия. Экспериментально — лучше всего работает на печатных ценниках.';
}
