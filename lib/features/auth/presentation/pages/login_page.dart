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

class _LoginViewMobile extends StatefulWidget {
  _LoginViewMobile({super.key});

  @override
  State<_LoginViewMobile> createState() => _LoginViewMobileState();
}

class _LoginViewMobileState extends State<_LoginViewMobile> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is AuthenticationLoadFailure) Text(state.message),
                UITextFormField(
                  autofillHints: [AutofillHints.email],
                  controller: emailController,
                  validation: (_) {
                    return null;
                  },
                  label: 'Email',
                ),
                UITextFormField(
                  autofillHints: [AutofillHints.password],
                  controller: passwordController,
                  validation: (_) {
                    return null;
                  },
                  label: 'Password',
                ),
                //Sign up button
                GestureDetector(
                  onTap: () => setState(() {
                    _isSignIn = !_isSignIn;
                  }),
                  child: Text(
                    _isSignIn ? "No Account yet? Sign up" : "Back to login",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                //Login button
                GestureDetector(
                  child: UICard(
                    useGradient: true,
                    child: Center(
                      child: Text(_isSignIn ? "Login" : "Sign Up",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                    ),
                  ),
                  onTap: () {
                    _isSignIn
                        ? BlocProvider.of<AuthenticationBloc>(context).add(
                            LoggedIn(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          )
                        : BlocProvider.of<AuthenticationBloc>(context).add(
                            SignedUp(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
