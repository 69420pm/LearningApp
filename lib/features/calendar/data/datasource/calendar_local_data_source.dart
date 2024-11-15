import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';

abstract class CalendarLocalDataSource {
  Future<CalendarModel> getCalendar();
  Future<void> saveCalendar(CalendarModel calendar);
  Stream<CalendarModel?> watchCalendar();

  Future<void> deleteCalendar();
}

class CalendarHive implements CalendarLocalDataSource {
  final Box<String> calendarBox;

  CalendarHive({
    required this.calendarBox,
  });

  @override
  Future<CalendarModel> getCalendar() async {
    final calendar = calendarBox.get("calendar");
    if (calendar == null) {
      return CalendarModel();
    }
    return CalendarModel.fromJson(jsonDecode(calendar));
  }

  @override
  Future<void> saveCalendar(CalendarModel calendar) async {
    await calendarBox.put("calendar", jsonEncode(calendar.toJson()));
  }

  @override
  Stream<CalendarModel?> watchCalendar() {
    return calendarBox.watch(key: "calendar").map((event) {
      if (event.value == null) {
        return null;
      }
      return CalendarModel.fromJson(jsonDecode(event.value!));
    });
  }

  @override
  Future<void> deleteCalendar() async {
    await calendarBox.delete("calendar");
  }
}
