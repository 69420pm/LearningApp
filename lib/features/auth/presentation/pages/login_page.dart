import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/app_router.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:learning_app/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:learning_app/features/auth/presentation/widgets/email_text_field.dart';
import 'package:learning_app/features/auth/presentation/widgets/password_text_field.dart';
import 'package:learning_app/features/auth/presentation/widgets/reset_password_bs.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: ResponsiveLayout(
        mobile: _LoginViewMobile(),
      ),
    );
  }
}

class _LoginViewMobile extends StatelessWidget {
  _LoginViewMobile({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    login() {
      if (formKey.currentState?.validate() ?? false) {
        context.read<SignInBloc>().add(
              SignIn(
                email: emailController.text,
                password: passwordController.text,
              ),
            );
      }
    }

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccessful) {
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
                    PasswordTextField(
                        passwordController: passwordController,
                        onSubmitted: login),
                    GestureDetector(
                      onTap: () => UIBottomSheet.showUIBottomSheet(
                        builder: (context) => ResetPasswordBS(),
                        context: context,
                      ),
                      child: const Text(
                        "Reset Password",
                        style: UIText.normal,
                      ),
                    ),
                    Text(
                      (state is SignInFailure) ? state.message : "",
                      style: UIText.normal.copyWith(
                        color: UIColors.red,
                      ),
                    ),

                    //Sign up button
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    //Login button
                    UICardButton(
                      color: UIColors.primary,
                      text: Text(
                        state is SignInLoading ? "Loading..." : "Login",
                        style: UIText.labelBold.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () => login(),
                    ),
                    const SizedBox(height: UIConstants.itemPaddingLarge),
                    GestureDetector(
                      onTap: () => context.go(
                        "${AppRouter.landingPath}/${AppRouter.registerPath}",
                      ),
                      child: const Text(
                        "No Account yet? Sign up",
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
