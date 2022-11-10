import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/view/add_card.dart';
import 'package:learning_app/add_group/cubit/add_group_cubit.dart';
import 'package:learning_app/add_group/view/add_group.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/overview/view/overview_page.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository);

  final CardsRepository _cardsRepository;

  final HomeCubit _homeCubit = HomeCubit();
  late AddGroupCubit _addGroupCubit = AddGroupCubit(_cardsRepository);

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _homeCubit,
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
      case '/add_group':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _addGroupCubit,
            child: AddGroupPage(),
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
