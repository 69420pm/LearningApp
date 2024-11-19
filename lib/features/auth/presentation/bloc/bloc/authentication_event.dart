part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class SignedUp extends AuthenticationEvent {
  final String email;
  final String password;

  const SignedUp({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class LoggedIn extends AuthenticationEvent {
  final String email;
  final String password;

  const LoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class LoggedOut extends AuthenticationEvent {}

final class AuthenticationStatusChecked extends AuthenticationEvent {}
