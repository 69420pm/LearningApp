import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/bloc_observer.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/theme/color_schemes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Bloc.observer = MyGlobalObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,

      //Theme
      theme: ThemeData(
        colorScheme: lightColorScheme,
        // only to remove border for expansion tile
        dividerColor: Colors.transparent,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        // only to remove border for expansion tile
        dividerColor: Colors.transparent,
        useMaterial3: true,
      ),
      //dark for development, else ThemeMode.system
      themeMode: ThemeMode.dark,

      //Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      locale: null, //defaults to top of supportedLocals
    );
  }
}
