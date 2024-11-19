import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/diff_match/diff/delta.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _RegisterViewMobile(),
    );
  }
}

class _RegisterViewMobile extends StatelessWidget {
  _RegisterViewMobile({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    register() {
      if (formKey.currentState!.validate()) {
        BlocProvider.of<AuthenticationBloc>(context).add(
          SignedUp(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
      }
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.pageHorizontalPadding),
            child: AutofillGroup(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UITextFormField(
                      autofillHints: [AutofillHints.email],
                      inputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      validation: (text) {
                        if (text!.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text)) {
                          return "Invalid email";
                        }
                      },
                      label: 'Email',
                    ),
                    UITextFormField(
                      autofillHints: [AutofillHints.password],
                      inputType: TextInputType.visiblePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      validation: (text) {
                        if (text!.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                      },
                      label: 'Password',
                    ),
                    UITextFormField(
                      autofillHints: [AutofillHints.password],
                      inputType: TextInputType.visiblePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      controller: passwordConfirmController,
                      validation: (text) {
                        if (text != passwordController.text) {
                          return "Passwords do not match";
                        }
                      },
                      label: 'Confirm Password',
                      onFieldSubmitted: (_) => register(),
                    ),
                    Text(
                        (state is AuthenticationLoadFailure)
                            ? state.message
                            : "",
                        style: UIText.normal.copyWith(
                          color: UIColors.red,
                        )),

                    //Sign up button
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    //Login button
                    UICardButton(
                      color: UIColors.primary,
                      text: Text(
                        "Sign Up",
                        style: UIText.labelBold.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () => register(),
                    ),
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    GestureDetector(
                      onTap: () => context.go(
                        "${AppRouter.landingPath}/${AppRouter.loginPath}",
                      ),
                      child: const Text(
                        "Already have an account? Login",
                        style: UIText.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
