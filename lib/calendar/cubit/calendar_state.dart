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

final class CalendarClassTestChanged extends CalendarState {
  ClassTest classTest;
  CalendarClassTestChanged({required this.classTest});
  @override
  List<Object> get props => [classTest];
}

final class CalendarStreakChanged extends CalendarState {
  int streak;
  CalendarStreakChanged({required this.streak});
  @override
  List<Object> get props => [streak];
}

final class CalendarStreakSaverChanged extends CalendarState {
  int streakSaver;
  CalendarStreakSaverChanged({required this.streakSaver});
  @override
  List<Object> get props => [streakSaver];
}
