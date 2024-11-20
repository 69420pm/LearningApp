part of 'reset_password_bloc.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {}

final class PasswordResetEmailInProgress extends ResetPasswordState {}

final class PasswordResetEmailSent extends ResetPasswordState {}

final class PasswordResetEmailFailure extends ResetPasswordState {
  final String message;

  const PasswordResetEmailFailure(this.message);

  @override
  List<Object> get props => [message];
}
