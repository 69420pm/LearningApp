import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';

class Streak extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  Streak({
    required DateTime start,
    required DateTime end,
  })  : startDate = DateTime(start.year, start.month, start.day),
        endDate = DateTime(end.year, end.month, end.day);

  Streak.withLength({required DateTime start, required int lengthInDays})
      : startDate = DateTime(start.year, start.month, start.day),
        endDate = DateTime(start.year, start.month, start.day)
            .add(Duration(days: lengthInDays - 1));

  get lengthInDays => endDate.difference(startDate).inDays + 1;

  bool contains(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate) ||
        date.isSameDay(startDate) ||
        date.isSameDay(endDate);
  }

  @override
  List<Object> get props => [startDate, endDate];

  @override
  String toString() {
    return 'Streak(startDate: $startDate, endDate: $endDate)';
  }
}
