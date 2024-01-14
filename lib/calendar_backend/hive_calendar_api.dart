import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/calendar_backend/calendar_api/calendar_api.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';

class HiveCalendarApi extends CalendarApi {
  HiveCalendarApi(this._calendarDayBox, this._calendarBox);

  final Box<CalendarDay> _calendarDayBox;
  final Box<dynamic> _calendarBox;

  @override
  Future<void> saveCalendarDay(CalendarDay day) {
    day = day.copyWith(
        date: DateTime(day.date.year, day.date.month, day.date.day));
    return _calendarDayBox.put(day.date.toIso8601String(), day);
  }

  @override
  ValueListenable<Box<CalendarDay>> getCalendarDay() {
    return _calendarDayBox.listenable();
  }

  @override
  Future<CalendarDay?> getCalendarDayByDate(DateTime dateTime) async {
    return _calendarDayBox.get(dateTime.toIso8601String());
  }

  @override
  Future<int> getStreakSaver() async {
    return await _calendarBox.get('streak_saver') as int? ?? 0;
  }

  @override
  Future<void> saveStreakSaver(int streakSaver) async {
    await _calendarBox.put('streak_saver', streakSaver.clamp(0, 2));
  }

  @override
  Future<void> changeStreakToday(bool streakCompleted) async {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var calendarDay = _calendarDayBox.get(today.toIso8601String()) ??
        CalendarDay(
            uid: Uid().uid(),
            date: today,
            learnedCardsIds: [],
            streakCompleted: streakCompleted);
    final streakSaver = await getStreakSaver();

    var yesterday =
        await getCalendarDayByDate(today.subtract(const Duration(days: 1)));
    var theDayBeforeYesterday =
        await getCalendarDayByDate(today.subtract(const Duration(days: 2)));
    final twoDaysBeforeYesterday =
        await getCalendarDayByDate(today.subtract(const Duration(days: 3)));
    if (!streakCompleted) {
      calendarDay = calendarDay.copyWith(streakCompleted: streakCompleted);
      return saveCalendarDay(calendarDay);
    }

    // streak completed == true
    if (streakSaver == 2) {
      if (twoDaysBeforeYesterday != null &&
          twoDaysBeforeYesterday.streakCompleted == true &&
          theDayBeforeYesterday != null &&
          !theDayBeforeYesterday.streakCompleted &&
          yesterday != null &&
          !yesterday.streakCompleted) {
        calendarDay = calendarDay.copyWith(streakCompleted: streakCompleted);
        yesterday = yesterday.copyWith(streakCompleted: true);
        theDayBeforeYesterday =
            theDayBeforeYesterday.copyWith(streakCompleted: true);
        await saveCalendarDay(yesterday);
        await saveCalendarDay(theDayBeforeYesterday);
        await saveStreakSaver(0);
        return saveCalendarDay(calendarDay);
      }
      if (theDayBeforeYesterday != null &&
          theDayBeforeYesterday.streakCompleted &&
          yesterday != null &&
          !yesterday.streakCompleted) {
        calendarDay = calendarDay.copyWith(streakCompleted: streakCompleted);
        yesterday = yesterday.copyWith(streakCompleted: true);
        await saveCalendarDay(yesterday);
        await saveStreakSaver(1);

        return saveCalendarDay(calendarDay);
      }
    } else if (streakSaver == 1) {
      if (theDayBeforeYesterday != null &&
          theDayBeforeYesterday.streakCompleted &&
          yesterday != null &&
          !yesterday.streakCompleted) {
        calendarDay = calendarDay.copyWith(streakCompleted: streakCompleted);
        yesterday = yesterday.copyWith(streakCompleted: true);
        await saveCalendarDay(yesterday);
        await saveStreakSaver(0);

        return saveCalendarDay(calendarDay);
      }
    } else {
      calendarDay = calendarDay.copyWith(streakCompleted: streakCompleted);
      await saveCalendarDay(calendarDay);
    }
  }
}
