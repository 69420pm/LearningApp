import 'package:flutter/material.dart';
import 'package:learning_app_clone/core/app_router.dart';
import 'package:learning_app_clone/core/theme/color_schemes.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      //dark for development, else ThemeMode.system
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
