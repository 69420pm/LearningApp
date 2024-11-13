import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streak.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class Streaks {
  final List<Streak> _streaks = List.empty(growable: true);
  get streaks => _streaks;

  Streaks();

  Streaks.custom({required List<Streak> streaks}) {
    _streaks.addAll(streaks);
  }

  get lastStreak => _streaks.last;
  get isTodayInStreak => lastStreak.contains(DateTime.now());

  void addTodayToStreak() {
    if (isTodayInStreak) {
      _streaks.last.addDay(DateTime.now());
    } else {
      _streaks.add(Streak.newStreak(start: DateTime.now()));
    }
  }

  void addDayToStreak(DateTime day) {
    if (!contains(day)) {
      if (contains(day.dayBefore()) && contains(day.dayAfter())) {
        //connect two streaks
        final indexBefore = _streaks
            .firstWhere((element) => element.endDate == day.dayBefore());
        final indexAfter = _streaks
            .firstWhere((element) => element.startDate == day.dayAfter());

        final start = indexBefore.startDate;
        final end = indexAfter.endDate;

        _streaks.remove(indexAfter);
        _streaks.remove(indexBefore);
        _streaks.add(Streak(start: start, end: end));
      } else if (contains(day.dayBefore())) {
        //add day after the streak
        final index = _streaks
            .indexWhere((element) => element.endDate == day.dayBefore());
        _streaks[index].addDay(day);
      } else if (contains(day.dayAfter())) {
        //add day before the streak
        final index = _streaks
            .indexWhere((element) => element.startDate == day.dayAfter());
        _streaks[index].addDay(day);
      } else {
        //create new streak
        _streaks.add(Streak.newStreak(start: day));
      }
    }
  }

  bool contains(DateTime day) {
    for (var streak in _streaks) {
      if (streak.contains(day)) {
        return true;
      }
    }
    return false;
  }

  StreaksModel toModel() {
    return StreaksModel.custom(
        streaks: _streaks.map((e) => e.toModel()).toList());
  }

  @override
  String toString() {
    return _streaks
        .map((e) => ("${e.startDate.day}-${e.endDate.day}"))
        .join(", ");
  }
}
