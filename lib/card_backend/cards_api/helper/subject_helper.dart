import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
class SubjectHelper {
  static int daysTillNextClassTest(List<ClassTest>? classTests, DateTime rightNow) {
    if(classTests == null){
      return -1;
    }
    final classTestDates = <DateTime>[];
    DateTime? nextClassTest;
    for (final element in classTests) {
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
