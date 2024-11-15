import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

class Calendar {
  Streaks _streaks = Streaks();
  Streaks get streaks => _streaks;

  int _streakSaver = 0;
  int get streakSaver => _streakSaver;
  set streakSaver(int value) {
    _streakSaver = value;
    if (_streakSaver > _maxStreakSaver) {
      _streakSaver = _maxStreakSaver;
    } else if (_streakSaver < 0) {
      _streakSaver = 0;
    }
  }

  int _maxStreakSaver = 0;
  int get maxStreakSaver => _maxStreakSaver;
  set maxStreakSaver(int value) {
    _maxStreakSaver = value;
    if (_maxStreakSaver < 0) {
      _maxStreakSaver = 0;
    }
  }

  Calendar({streaks, streakSaver = 3, maxStreakSaver = 3}) {
    _streaks = streaks ?? Streaks();
    _streakSaver = streakSaver;
    _maxStreakSaver = maxStreakSaver;
  }

  CalendarModel toModel() {
    return CalendarModel(
      streaks: _streaks.toModel(),
      streakSaver: _streakSaver,
      maxStreakSaver: _maxStreakSaver,
    );
  }
}
