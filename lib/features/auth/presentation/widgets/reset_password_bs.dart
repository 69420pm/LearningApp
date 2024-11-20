import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_fields/ui_text_field.dart';
import 'package:learning_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:learning_app/features/auth/presentation/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:learning_app/features/auth/presentation/widgets/email_text_field.dart';

class ResetPasswordBS extends StatelessWidget {
  const ResetPasswordBS({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: _BSContent(),
    );
  }
}

class _BSContent extends StatelessWidget {
  _BSContent({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
      if (state is PasswordResetEmailSent) {
        Navigator.of(context).pop();
      }
    }, builder: (context, state) {
      return UIBottomSheet(
        child: Column(
          children: [
            EmailTextField(
              emailController: emailController,
              onSubmitted: () => context.read<ResetPasswordBloc>().add(
                    ResetPassword(email: emailController.text),
                  ),
            ),
            UICardButton(
              onPressed: () {
                context.read<ResetPasswordBloc>().add(
                      ResetPassword(email: emailController.text),
                    );
              },
              text: Text(
                  state is PasswordResetEmailInProgress
                      ? "Sending email"
                      : state is PasswordResetEmailSent
                          ? "Email send successfully "
                          : state is PasswordResetEmailFailure
                              ? "Error: ${state.message}"
                              : "Reset Password",
                  style: UIText.normal),
            ),
          ],
        ),
      );
    });
    ;
  }
}
