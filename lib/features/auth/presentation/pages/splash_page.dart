import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    print("moin");
    // wait for 2 seconds to show splash screen
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthenticationBloc>().add(AuthenticationStatusChecked());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text('Splash Page', style: TextStyle(fontSize: 20)),
          ),
          CircularProgressIndicator()
        ],
      ),
    ));
  }
}
