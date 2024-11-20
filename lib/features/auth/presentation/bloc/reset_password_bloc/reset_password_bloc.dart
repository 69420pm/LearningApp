import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPassword>((event, emit) async {
      emit(PasswordResetEmailInProgress());

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: event.email)
          .then((value) => emit(PasswordResetEmailSent()), onError: (e) {
        if (e.code == 'user-not-found') {
          emit(
            const PasswordResetEmailFailure('No user found for that email.'),
          );
        } else if (e.code == 'invalid-email') {
          emit(
            const PasswordResetEmailFailure(
                'The email address is badly formatted.'),
          );
        } else {
          emit(PasswordResetEmailFailure(e.toString()));
        }
      });
    });
  }
}
