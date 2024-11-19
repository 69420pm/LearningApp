import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:learning_app/features/auth/presentation/pages/login_page.dart';
import 'package:learning_app/features/auth/presentation/pages/splash_page.dart';
import 'package:learning_app/features/calendar/presentation/pages/calendar_page.dart';
import 'package:learning_app/features/learn/presentation/pages/learn_page.dart';
import 'package:learning_app/features/quill_editor/presentation/quill_test.dart';
import 'package:learning_app/features/subject/presentation/pages/subject_page.dart';
import 'package:learning_app/features/home/presentation/pages/home_page.dart';
import 'package:learning_app/injection_container.dart';

enum AppRouteName { splash, login, home, calendar, learn, editor, subject }

class AppRouter {
  static const String homePath = '/';
  static const String splashPath = '/splash';
  static const String loginPath = '/login';

  static const String calendarPath = 'calendar';
  static const String learnPath = 'learn';
  static const String editorPath = 'editor';
  static const String subjectPath = 'subject/:subjectId';
}

final GoRouter router = GoRouter(
  initialLocation: AppRouter.splashPath,

  routes: [
    GoRoute(
      path: AppRouter.splashPath,
      name: AppRouteName.splash.name,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRouter.loginPath,
      name: AppRouteName.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRouter.homePath,
      name: AppRouteName.home.name,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: AppRouter.subjectPath,
          name: AppRouteName.subject.name,
          builder: (context, state) {
            return SubjectPage(subjectId: state.pathParameters['subjectId']!);
          },
        ),
        GoRoute(
          path: AppRouter.editorPath,
          name: AppRouteName.editor.name,
          builder: (context, state) {
            return const QuillTest();
          },
        ),
        GoRoute(
          path: AppRouter.calendarPath,
          name: AppRouteName.calendar.name,
          builder: (context, state) {
            return const CalendarPage();
          },
        ),
        GoRoute(
          path: AppRouter.learnPath,
          name: AppRouteName.learn.name,
          builder: (context, state) {
            return LearnPage();
          },
        ),
      ],
    )
  ],
  // changes on the listenable will cause the router to refresh it's route
  refreshListenable: StreamToListenable([sl<AuthenticationBloc>().stream]),
  //The top-level callback allows the app to redirect to a new location.
  redirect: (context, state) {
    print("moin");
    final isAuthenticated = sl<AuthenticationBloc>().state is Authenticated;
    final isUnAuthenticated = sl<AuthenticationBloc>().state is Unauthenticated;

    // Redirect to the login page if the user is not authenticated, and if authenticated, do not show the login page
    if (isUnAuthenticated &&
        !state.matchedLocation.contains(AppRouter.loginPath)) {
      return AppRouter.loginPath;
    }
    // Redirect to the home page if the user is authenticated
    else if (isAuthenticated && state.fullPath == AppRouter.splashPath) {
      print("home");
      return AppRouter.homePath;
    }
    return null;
  },
);

class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
