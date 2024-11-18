import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Unauthenticated()) {
    on<LoggedIn>((event, emit) {
      emit(AuthenticationLoadInProgress());
      // Here you would write the login system code
      // For simplicity, let's assume the login is successful
      emit(Authenticated());
    });

    on<LoggedOut>((event, emit) {
      emit(AuthenticationLoadInProgress());
      // Here you would write the logout system code
      emit(Unauthenticated());
    });

    on<AuthenticationStatusChecked>((event, emit) {
      emit(AuthenticationLoadInProgress());
      emit(Authenticated());
    });
  }
}
