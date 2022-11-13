import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/view/add_card_page.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_page.dart';

import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/overview/view/overview_page.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository);

  final CardsRepository _cardsRepository;

  final HomeCubit _homeCubit = HomeCubit();
  late final AddSubjectCubit _addSubjectCubit =
      AddSubjectCubit(_cardsRepository);
  late final OverviewBloc _overviewBloc = OverviewBloc(_cardsRepository)
    ..add(OverviewSubjectSubscriptionRequested());

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(
                value: _overviewBloc,
              ),
            ],
            child: HomePage(),
          ),
        );
      case '/add_card':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _homeCubit,
            child: AddCardPage(),
          ),
        );
      case '/add_subject':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(
                value: _addSubjectCubit,
              ),
            ],
            child: AddSubjectPage(),
          ),
        );
      // error route
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorPage(
            errorMessage: 'Internal routing error',
          ),
        );
    }
  }
}
