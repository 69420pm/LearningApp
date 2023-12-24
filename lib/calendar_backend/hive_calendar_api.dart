import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_app/calendar_backend/calendar_api/calendar_api.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';

class HiveCalendarApi extends CalendarApi {
  HiveCalendarApi(this._calendarBox);

  final Box<CalendarDay> _calendarBox;

  @override
  Future<void> saveCalendarDay(CalendarDay day) {
    return _calendarBox.put(day.date.toIso8601String(), day);
  }

  @override
  ValueListenable<Box<CalendarDay>> getCalendarDay() {
    return _calendarBox.listenable();
  }
  
  @override
  Future<CalendarDay?> getCalendarDayByDate(DateTime dateTime) async {
    return _calendarBox.get(dateTime.toIso8601String());
  }
}
