import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/data/models/streak_model.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class Streak extends Equatable {
  DateTime _startDate;
  DateTime _endDate;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  Streak({
    required DateTime start,
    required DateTime end,
  })  : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(end.year, end.month, end.day);

  Streak.withLength({required DateTime start, required int lengthInDays})
      : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(start.year, start.month, start.day)
            .add(Duration(days: lengthInDays - 1));

  Streak.newStreak({required DateTime start})
      : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(start.year, start.month, start.day);

  addDay(DateTime date) {
    if (date.isSameDay(_endDate.add(const Duration(days: 1)))) {
      _endDate = date;
    } else if (date.isSameDay(_startDate.subtract(const Duration(days: 1)))) {
      _startDate = date;
    } else {
      throw Exception('Date is not adjacent to the streak');
    }
  }

  get lengthInDays => _endDate.difference(_startDate).inDays + 1;

  bool contains(DateTime date) {
    return date.year >= _startDate.year &&
        date.year <= _endDate.year &&
        date.month >= _startDate.month &&
        date.month <= _endDate.month &&
        date.day >= _startDate.day &&
        date.day <= _endDate.day;
  }

  @override
  List<Object> get props => [_startDate, _endDate];

  @override
  String toString() {
    return 'Streak(startDate: $_startDate, endDate: $_endDate)';
  }

  StreakModel toModel() {
    return StreakModel(
      start: _startDate,
      end: _endDate,
    );
  }
}
