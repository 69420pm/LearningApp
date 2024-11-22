import 'dart:async';

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

class _VerifyEmailScreenMobile extends StatefulWidget {
  _VerifyEmailScreenMobile({super.key});

  @override
  State<_VerifyEmailScreenMobile> createState() =>
      _VerifyEmailScreenMobileState();
}

class _VerifyEmailScreenMobileState extends State<_VerifyEmailScreenMobile> {
  final TextEditingController _codeController = TextEditingController();

  late Timer timer;
  @override
  void initState() {
    if (context.read<EmailVerifyBloc>().state is EmailVerifyInitial) {
      context.read<EmailVerifyBloc>().add(SendVerifyEmail());
    }
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (context.mounted) {
        FirebaseAuth.instance.currentUser?.reload().then((value) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationStatusChecked());
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                if (state is EmailSendFailure)
                  UICardButton(
                    onPressed: () {
                      context.read<EmailVerifyBloc>().add(SendVerifyEmail());
                    },
                    text: const Text("Resent Email"),
                  ),
                const SizedBox(height: 20),
                UICardButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(LoggedOut());
                    },
                    text: const Text("logout"))
              ],
            ),
          ),
        );
      },
    );
  }
}
