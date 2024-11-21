import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_card_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_fields/ui_text_field.dart';
import 'package:learning_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:learning_app/features/auth/presentation/bloc/email_verify/email_verify_bloc.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerifyBloc(),
      child: ResponsiveLayout(
        mobile: _VerifyEmailScreenMobile(),
      ),
    );
  }
}

class _VerifyEmailScreenMobile extends StatelessWidget {
  _VerifyEmailScreenMobile({super.key});

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.emailVerified);

    return BlocBuilder<EmailVerifyBloc, EmailVerifyState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Verify your email to continue'),
                UICardButton(
                    onPressed: () {
                      context.read<EmailVerifyBloc>().add(SendVerifyEmail());
                    },
                    text: Text(state is EmailSendingLoading
                        ? 'Sending...'
                        : state is EmailVerifyInitial
                            ? 'Send email'
                            : state is EmailSendSuccess
                                ? 'Resend verification email'
                                : state is EmailSendFailure
                                    ? state.message
                                    : '')),
                const SizedBox(height: 20),
                UICardButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(LoggedOut());
                    },
                    text: Text("logout"))
              ],
            ),
          ),
        );
      },
    );
  }
}
