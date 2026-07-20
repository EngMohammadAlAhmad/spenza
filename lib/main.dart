import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/app.dart';
import 'package:spenza/core/observers/app_bloc_observer.dart';
import 'package:spenza/core/services/crash_reporter.dart';
import 'package:spenza/core/translations/codegen_loader.g.dart';
import 'package:spenza/firebase_options.dart';
//import 'package:spenza/core/translations/codegen_loader.g.dart';
import 'package:spenza/injection_locator.dart' as di;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await di.init();

    FlutterError.onError = (details) {
      di.sl<CrashReporter>().recordError(details.exception, details.stack, fatal: true);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      di.sl<CrashReporter>().recordError(error, stack, fatal: true);
      return true;
    };

    Bloc.observer = AppBlocObserver();

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
  }, (error, stack) => di.sl<CrashReporter>().recordError(error, stack, fatal: true));
}

// dart run easy_localization:generate -S "assets/translations" -O "lib/core/translations"
// dart run easy_localization:generate -S "assets/translations" -O "lib/core/translations" -o "locale_keys.g.dart" -f keys