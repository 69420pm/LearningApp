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
  List<Object> get props => [
        dateTime.day,
        dateTime.year,
        dateTime.month,
        dateTime.hour,
        dateTime.minute,
        dateTime.second
      ];
}

final class ClassTestChanged extends CalendarState {
  ClassTest classTest;
  ClassTestChanged({required this.classTest});
  @override
  List<Object> get props => [classTest];
}
