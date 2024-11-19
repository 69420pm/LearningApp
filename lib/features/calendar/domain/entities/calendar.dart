import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

class Calendar extends Equatable {
  Streaks _streaks = Streaks();
  Streaks get streaks => _streaks;
  //methode to update _changedate if streaks is updated
  void updateChangeDate() {
    _changeDate = DateTime.now();
  }

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

  DateTime _changeDate = DateTime.now();
  DateTime get changeDate => _changeDate;

  Calendar({streaks, streakSaver = 3, maxStreakSaver = 3, changeDate}) {
    _streaks = streaks ?? Streaks();
    _streakSaver = streakSaver;
    _maxStreakSaver = maxStreakSaver;
    _changeDate = changeDate ?? DateTime.now();
  }

  CalendarModel toModel() {
    return CalendarModel(
      streaks: _streaks.toModel(),
      streakSaver: _streakSaver,
      maxStreakSaver: _maxStreakSaver,
      changeDate: _changeDate,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [_streaks, _streakSaver, _maxStreakSaver, _changeDate];
}
