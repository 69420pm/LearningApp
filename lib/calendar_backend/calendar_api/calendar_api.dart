import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';

abstract class CalendarApi {
  const CalendarApi();

  /// saves a [streak]
  Future<void> saveCalendarDay(CalendarDay day);

  /// returns all streaks
  ValueListenable<Box<CalendarDay>> getCalendarDay();

  /// get calendarDay by given a datetime
  Future<CalendarDay?> getCalendarDayByDate(DateTime dateTime);

  Future<int> getStreakSaver();

  Future<void> saveStreakSaver(int streakSaver);

  /// change streak completed of calendarDay today
  Future<void> changeStreakToday(bool streakCompleted);
}
