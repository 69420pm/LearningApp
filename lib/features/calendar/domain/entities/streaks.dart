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
      if (_streaks.contains(day.dayBefore())) {
        _streaks[_streaks.indexWhere(
          (element) => element.endDate == day.dayBefore(),
        )]
            .addDay(day);
      } else if (_streaks.contains(day.dayAfter())) {
        DateTime end = _streaks[_streaks.indexWhere(
          (element) => element.startDate == day.dayAfter(),
        )]
            .endDate;
        _streaks.remove(_streaks[_streaks.indexWhere(
          (element) => element.startDate == day.dayAfter(),
        )]);
        _streaks.add(Streak(start: day, end: end));
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
}
