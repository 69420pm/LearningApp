// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning_app/app/routes/app_router.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/l10n/l10n.dart';

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
  AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsRepository = context.read<CardsRepository>();
    final appRouter = AppRouter(cardsRepository);
    return MaterialApp(
      title: "Learning App",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
