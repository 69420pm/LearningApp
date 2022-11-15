import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/view/add_card_page.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_page.dart';

import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/edit_subject/bloc/edit_subject_bloc.dart';
import 'package:learning_app/edit_subject/view/edit_subject_page.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository);

  final CardsRepository _cardsRepository;

  final HomeCubit _homeCubit = HomeCubit();
  late final AddSubjectCubit _addSubjectCubit =
      AddSubjectCubit(_cardsRepository);
  late final EditSubjectBloc _editSubjectBloc =
      EditSubjectBloc(_cardsRepository);
  late final AddCardCubit _addCardCubit = AddCardCubit(_cardsRepository);
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(value: _addCardCubit),
            ],
            child: AddCardPage(
                recommendedSubjectParentId: routeSettings.arguments as String?),
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
      case '/edit_subject':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(
                value: _editSubjectBloc,
              ),
            ],
            child: EditSubjectPage(
              subjectToEdit: routeSettings.arguments! as Subject,
            ),
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
