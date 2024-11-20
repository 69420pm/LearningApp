import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUp>((event, emit) async {
      emit(SignUpLoading());
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        )
            .whenComplete(() {
          emit(SignUpSuccessful());
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const SignUpFailure('The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          emit(const SignUpFailure(
              'The account already exists for that email.'));
        } else if (e.code == 'invalid-email') {
          emit(
            const SignUpFailure('The email address is badly formatted.'),
          );
        } else {
          emit(SignUpFailure(e.toString()));
        }
      }
    });
  }
}
