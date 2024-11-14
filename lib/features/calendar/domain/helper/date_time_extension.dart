extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool isToday() {
    return isSameDay(DateTime.now());
  }

  DateTime dayBefore() {
    return addDays(-1);
  }

  DateTime dayAfter() {
    return addDays(1);
  }

  DateTime onlyDay() {
    return DateTime(year, month, day);
  }

  DateTime addDays(int days) {
    var newDay = add(Duration(days: days));

    //fixes issue with daylight saving time
    if (newDay.hour == 23) {
      newDay = newDay.add(const Duration(hours: 1));
    } else if (newDay.hour == 1) {
      newDay = newDay.subtract(const Duration(hours: 1));
    }

    return newDay;
  }
}
