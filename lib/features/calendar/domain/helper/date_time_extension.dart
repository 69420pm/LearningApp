extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool isToday() {
    return isSameDay(DateTime.now());
  }

  DateTime dayBefore() {
    return subtract(const Duration(days: 1));
  }

  DateTime dayAfter() {
    return add(const Duration(days: 1));
  }
}
