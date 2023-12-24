import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:learning_app/calendar_backend/calendar_api/calendar_api.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';

class CalendarRepository {
  const CalendarRepository({required CalendarApi calendarApi})
      : _calendarApi = calendarApi;
  final CalendarApi _calendarApi;

  /// saves a [day]
  Future<void> saveCalendarDay(CalendarDay day) => _calendarApi.saveCalendarDay(day);

  /// returns all streaks
   ValueListenable<Box<CalendarDay>> getStreaks() => _calendarApi.getCalendarDay();

   /// get calendarDay by given a datetime
  Future<CalendarDay?> getCalendarDayByDate(DateTime dateTime) => _calendarApi.getCalendarDayByDate(dateTime);
}
