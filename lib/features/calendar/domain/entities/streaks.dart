import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class Streaks extends Equatable {
  final List<TimeSpan> _streaks = List.empty(growable: true);
  List<TimeSpan> get streaks => _streaks;

  Streaks();

  Streaks.custom({required List<TimeSpan> streaks}) {
    _streaks.addAll(streaks);
  }

  int currentStreakLength() {
    var currentStreak = _streaks.where((element) =>
        element.contains(DateTime.now().onlyDay()) ||
        element.contains(DateTime.now().onlyDay().dayBefore()));
    return currentStreak.isNotEmpty ? currentStreak.first.lengthInDays : 0;
  }

  bool get isTodayInStreak => contains(DateTime.now());

  void addDayToStreak(DateTime day) {
    if (!contains(day) &&
        (day.isSameDay(DateTime.now().onlyDay()) ||
            day.isBefore(DateTime.now().onlyDay()))) {
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
        _streaks.add(TimeSpan(start: start, end: end));
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
        _streaks.add(TimeSpan.newTimeSpan(start: day));
      }
    }
  }

  clear() {
    _streaks.clear();
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
      streaks: _streaks.map((e) => e.toModel()).toList(),
    );
  }

  @override
  String toString() {
    return _streaks
        .map((e) =>
            ("${e.startDate.day}.${e.startDate.month}-${e.endDate.day}.${e.endDate.month}"))
        .join("  ");
  }

  @override
  // TODO: implement props
  List<Object?> get props => [_streaks];
}
