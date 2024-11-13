import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class Streak extends Equatable {
  final DateTime _startDate;
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
    } else {
      throw Exception('Date is not the next day of the last day of the streak');
    }
  }

  get lengthInDays => _endDate.difference(_startDate).inDays + 1;

  bool contains(DateTime date) {
    return date.isAfter(_startDate) && date.isBefore(_endDate) ||
        date.isSameDay(_startDate) ||
        date.isSameDay(_endDate);
  }

  @override
  List<Object> get props => [_startDate, _endDate];

  @override
  String toString() {
    return 'Streak(startDate: $_startDate, endDate: $_endDate)';
  }
}
