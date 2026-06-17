import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/rates_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive backs the offline rate cache (docs §6.4). The box stores the rates as
  // a JSON string, so no generated TypeAdapters are needed.
  await Hive.initFlutter();
  await Hive.openBox<String>('rates_cache');

  // Load prefs once and inject so providers can read them synchronously.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const LensRateApp(),
    ),
  );
}
