import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/bloc_observer.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/theme/color_schemes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:learning_app/firebase_options.dart';
import 'package:learning_app/generated/l10n.dart';
import 'package:learning_app/injection_container.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);

  await di.init();
  Bloc.observer = MyGlobalObserver();
  runApp(const MyApp());
}

final AuthenticationBloc authBloc = AuthenticationBloc();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => sl<AuthenticationBloc>(),
      child: MaterialApp.router(
        title: 'Learning App',
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
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en', 'EN'),
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
