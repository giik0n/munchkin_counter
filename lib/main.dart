import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:munchkin_counter/screens/MyApp.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Wakelock.enable();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp()));
}
