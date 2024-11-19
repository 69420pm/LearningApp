import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationLoadInProgress()) {
    on<SignedUp>((event, emit) async {
      emit(AuthenticationLoadInProgress());
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        )
            .whenComplete(() {
          emit(Authenticated());
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const AuthenticationLoadFailure(
              'The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          emit(const AuthenticationLoadFailure(
              'The account already exists for that email.'));
        } else if (e.code == 'invalid-email') {
          emit(const AuthenticationLoadFailure(
              'The email address is badly formatted.'));
        } else {
          emit(AuthenticationLoadFailure(e.toString()));
        }
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoadInProgress());
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        )
            .whenComplete(() {
          emit(Authenticated());
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(
              const AuthenticationLoadFailure('No user found for that email.'));
        } else if (e.code == 'wrong-password') {
          emit(const AuthenticationLoadFailure(
              'Wrong password provided for that user.'));
        } else {
          emit(AuthenticationLoadFailure(e.toString()));
        }
      }
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoadInProgress());

      await FirebaseAuth.instance.signOut().whenComplete(() {
        emit(Unauthenticated());
      });
    });

    on<AuthenticationStatusChecked>((event, emit) async {
      emit(AuthenticationLoadInProgress());

      if (FirebaseAuth.instance.currentUser != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
