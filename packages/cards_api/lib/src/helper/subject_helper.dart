import 'package:cards_api/cards_api.dart';

class SubjectHelper {
  static int daysTillNextClassTest(Subject subject, DateTime rightNow) {
    final classTestDates = <DateTime>[];
    DateTime? nextClassTest;
    for (final element in subject.classTests) {
      DateTime? classTestDate;
      try {
        classTestDate = element.date;
      } catch (e) {
        continue;
      }
      if (classTestDate == null) continue;
      classTestDates.add(classTestDate);
      nextClassTest ??= classTestDate;
      if (classTestDate.compareTo(rightNow) < 0 &&
          nextClassTest.compareTo(classTestDate) > 0) {
        nextClassTest = classTestDate;
      }
    }

    if (nextClassTest == null) {
      return -1;
    }
    final difference = nextClassTest.difference(rightNow);
    if (difference.inDays < 0) {
      return -1;
    }
    return difference.inDays;
  }
}
