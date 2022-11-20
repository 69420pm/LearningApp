// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_repository/cards_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/app/routes/app_router.dart';
import 'package:learning_app/l10n/l10n.dart';
import 'package:ui_components/ui_components.dart';

class App extends StatelessWidget {
  const App({super.key, required this.cardsRepository});

  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: cardsRepository,
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsRepository = context.read<CardsRepository>();
    final appRouter = AppRouter(cardsRepository);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learning App',
        theme: _themeData(
            isLightMode: true, colorScheme: lightDynamic ?? lightColorScheme),
        darkTheme: _themeData(
            isLightMode: false, colorScheme: darkDynamic ?? darkColorScheme),
        themeMode: ThemeMode.dark, //TODO change later
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }

  ThemeData _themeData({
    required bool isLightMode,
    required ColorScheme colorScheme,
  }) {
    if (isLightMode) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: lightColorScheme.background),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark
            .copyWith(systemNavigationBarColor: darkColorScheme.background),
      );
    }

    return ThemeData(
      brightness: isLightMode ? Brightness.light : Brightness.dark,
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.openSansTextTheme(),
    );
  }
}
