part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class Unauthenticated extends AuthenticationState {}

final class AuthenticationLoadInProgress extends AuthenticationState {}

final class Authenticated extends AuthenticationState {}
