part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class LoggedOut extends AuthenticationEvent {}

final class AuthenticationStatusChecked extends AuthenticationEvent {}
