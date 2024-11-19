import 'dart:convert';

import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

class CalendarModel extends Calendar {
  CalendarModel({
    super.streaks,
    super.streakSaver,
    super.maxStreakSaver,
    super.changeDate,
  });
  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      streaks: StreaksModel.fromJson(json['streaks']),
      streakSaver: json['streakSaver'],
      maxStreakSaver: json['maxStreakSaver'],
      changeDate: DateTime.parse(json['changeDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'streaks': streaks.toModel().toJson(),
      'streakSaver': streakSaver,
      'maxStreakSaver': maxStreakSaver,
      'changeDate': changeDate.toIso8601String(),
    };
  }
}
