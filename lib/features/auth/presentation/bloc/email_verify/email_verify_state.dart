part of 'email_verify_bloc.dart';

sealed class EmailVerifyState extends Equatable {
  const EmailVerifyState();

  @override
  List<Object> get props => [];
}

final class EmailVerifyInitial extends EmailVerifyState {}

final class EmailSendingLoading extends EmailVerifyState {}

final class EmailSendSuccess extends EmailVerifyState {}

final class EmailSendFailure extends EmailVerifyState {
  final String message;

  const EmailSendFailure({required this.message});

  @override
  List<Object> get props => [message];
}
