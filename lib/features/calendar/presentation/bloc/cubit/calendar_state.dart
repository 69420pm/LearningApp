part of 'calendar_cubit.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

final class CalendarInitial extends CalendarState {}

final class CalendarLoading extends CalendarState {}

final class CalendarUpdated extends CalendarState {}

final class CalendarError extends CalendarState {
  final String errorMessage;

  CalendarError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class CalendarDeleted extends CalendarState {}
