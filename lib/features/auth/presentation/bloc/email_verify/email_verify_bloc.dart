import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

part 'email_verify_event.dart';
part 'email_verify_state.dart';

class EmailVerifyBloc extends Bloc<EmailVerifyEvent, EmailVerifyState> {
  EmailVerifyBloc() : super(EmailVerifyInitial()) {
    on<SendVerifyEmail>((event, emit) async {
      emit(EmailSendingLoading());

      await FirebaseAuth.instance.currentUser!.reload();

      await FirebaseAuth.instance.currentUser!.sendEmailVerification().then(
        (value) {
          print(FirebaseAuth.instance.currentUser!.email);
          emit(EmailSendSuccess());
        },
        onError: (error) {
          emit(EmailSendFailure(message: error.toString()));
        },
      );
    });
  }
}
