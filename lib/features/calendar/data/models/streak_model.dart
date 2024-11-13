import 'package:learning_app/features/calendar/domain/entities/streak.dart';

class StreakModel extends Streak {
  StreakModel({
    required super.start,
    required super.end,
  });

  StreakModel.withLength({
    required super.start,
    required super.lengthInDays,
  }) : super.withLength();

  StreakModel.newStreak({
    required super.start,
  }) : super.newStreak();

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'start': startDate.toIso8601String(),
      'end': endDate.toIso8601String(),
    };
  }
}
