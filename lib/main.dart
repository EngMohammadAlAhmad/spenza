import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spenza/app.dart';
import 'package:spenza/core/translations/codegen_loader.g.dart';
import 'package:spenza/firebase_options.dart';
//import 'package:spenza/core/translations/codegen_loader.g.dart';
import 'package:spenza/injection_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

// dart run easy_localization:generate -S "assets/translations" -O "lib/core/translations"
// dart run easy_localization:generate -S "assets/translations" -O "lib/core/translations" -o "locale_keys.g.dart" -f keys