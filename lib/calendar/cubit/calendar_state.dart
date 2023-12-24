part of 'calendar_cubit.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

final class CalendarShowMonth extends CalendarState {
  DateTime dateTime;
  CalendarShowMonth({required this.dateTime});
   @override
   List<Object> get props => [dateTime];
}
