import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/data/models/time_span_model.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class TimeSpan extends Equatable {
  DateTime _startDate;
  DateTime _endDate;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  TimeSpan({
    required DateTime start,
    required DateTime end,
  })  : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(end.year, end.month, end.day);

  TimeSpan.withLength({required DateTime start, required int lengthInDays})
      : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(start.year, start.month, start.day)
            .addDays(lengthInDays - 1);

  TimeSpan.newTimeSpan({required DateTime start})
      : _startDate = DateTime(start.year, start.month, start.day),
        _endDate = DateTime(start.year, start.month, start.day);

  addDay(DateTime date) {
    if (date.isSameDay(_endDate.addDays(1))) {
      _endDate = date;
    } else if (date.isSameDay(_startDate.addDays(-1))) {
      _startDate = date;
    } else {
      throw Exception('Date is not adjacent to the streak');
    }
  }

  int get lengthInDays => _endDate.difference(_startDate).inDays + 1;

  bool contains(DateTime date) {
    date = date.onlyDay();
    return date.isSameDay(_startDate) ||
        date.isSameDay(_endDate) ||
        (date.isAfter(_startDate) && date.isBefore(_endDate));
  }

  @override
  List<Object> get props => [_startDate, _endDate];

  @override
  String toString() {
    return 'Streak(startDate: $_startDate, endDate: $_endDate)';
  }

  TimeSpanModel toModel() {
    return TimeSpanModel(
      start: _startDate,
      end: _endDate,
    );
  }
}
