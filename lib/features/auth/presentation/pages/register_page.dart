import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:learning_app/features/auth/presentation/bloc/sing_up/sign_up_bloc.dart';
import 'package:learning_app/features/auth/presentation/widgets/email_text_field.dart';
import 'package:learning_app/features/auth/presentation/widgets/password_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: ResponsiveLayout(
        mobile: _RegisterViewMobile(),
      ),
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
        context.read<SignUpBloc>().add(
              SignUp(
                email: emailController.text,
                password: passwordController.text,
              ),
            );
      }
    }

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccessful) {
          context.read<AuthenticationBloc>().add(AuthenticationStatusChecked());
        }
      },
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
                    EmailTextField(emailController: emailController),
                    PasswordTextField(passwordController: passwordController),
                    PasswordTextField(
                      passwordController: passwordConfirmController,
                      passwordConfirm: passwordController.text,
                      onSubmitted: register,
                    ),
                    Text((state is SignUpFailure) ? state.message : "",
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
