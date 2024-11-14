import 'package:learning_app/features/calendar/domain/entities/time_span.dart';

class TimeSpanModel extends TimeSpan {
  TimeSpanModel({
    required super.start,
    required super.end,
  });

  TimeSpanModel.withLength({
    required super.start,
    required super.lengthInDays,
  }) : super.withLength();

  TimeSpanModel.newStreak({
    required super.start,
  }) : super.newTimeSpan();

  factory TimeSpanModel.fromJson(Map<String, dynamic> json) {
    return TimeSpanModel(
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
