import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationLoadInProgress()) {
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
