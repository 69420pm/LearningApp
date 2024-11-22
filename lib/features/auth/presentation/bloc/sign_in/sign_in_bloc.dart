import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      emit(SignInLoading());
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        )
            .whenComplete(() {
          emit(SignInSuccessful());
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(const SignInFailure('No user found for that email.'));
        } else if (e.code == 'wrong-password') {
          emit(const SignInFailure('Wrong password provided for that user.'));
        } else if (e.code == 'invalid-email') {
          emit(
            const SignInFailure('The email address is badly formatted.'),
          );
        } else if (e.code == 'invalid-credential') {
          emit(
            const SignInFailure('Wrong password provided.'),
          );
        } else {
          emit(SignInFailure(e.toString()));
        }
      }
    });
  }
}
