part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ResetPassword extends ResetPasswordEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object> get props => [email];
}
