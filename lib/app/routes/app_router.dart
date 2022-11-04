import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/counter/counter.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/overview/view/overview_page.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case '/add_card':
        return MaterialPageRoute(
          builder: (_) => const OverviewPage(),
        );
      // error route
      default:
        return MaterialPageRoute(
            builder: (_) => const ErrorPage(
                  errorMessage: 'Internal routing error',
                ));
    }
  }
}
