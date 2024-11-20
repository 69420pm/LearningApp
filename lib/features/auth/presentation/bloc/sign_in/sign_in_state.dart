part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccessful extends SignInState {}

final class SignInFailure extends SignInState {
  final String message;

  const SignInFailure(this.message);

  @override
  List<Object> get props => [message];
}
