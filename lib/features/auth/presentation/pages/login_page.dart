import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _LoginViewMobile(),
    );
  }
}

class _LoginViewMobile extends StatelessWidget {
  _LoginViewMobile({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UITextFormField(
                controller: emailController,
                validation: (_) {
                  return null;
                },
                label: 'Email',
              ),
              UITextFormField(
                controller: passwordController,
                validation: (_) {
                  return null;
                },
                label: 'Password',
              ),

              //Login button
              GestureDetector(
                child: UICard(
                  useGradient: true,
                  child: Center(
                    child: Text("Login",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
                    email: emailController.text,
                    password: passwordController.text,
                  ));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
