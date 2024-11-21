part of 'email_verify_bloc.dart';

sealed class EmailVerifyEvent extends Equatable {
  const EmailVerifyEvent();

  @override
  List<Object> get props => [];
}

class SendVerifyEmail extends EmailVerifyEvent {}

class ApplyVerifyCode extends EmailVerifyEvent {
  final String code;

  ApplyVerifyCode({required this.code});

  @override
  List<Object> get props => [code];
}
