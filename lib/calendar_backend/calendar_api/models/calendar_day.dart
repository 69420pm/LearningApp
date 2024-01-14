// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'calendar_day.g.dart';

@HiveType(typeId: 17)
class CalendarDay extends Equatable {
  /// unique never changing id
  @HiveField(0)
  final String uid;

  /// start date of streak
  @HiveField(1)
  final DateTime date;

  /// all card ids from the cards that got learned
  @HiveField(2)
  final List<String> learnedCardsIds;

  /// whether enough cards got learned to continue the streak
  @HiveField(3)
  final bool streakCompleted;

  const CalendarDay({
    required this.uid,
    required this.date,
    required this.learnedCardsIds,
    required this.streakCompleted,
  });

  CalendarDay copyWith({
    String? uid,
    DateTime? date,
    List<String>? learnedCardsIds,
    bool? streakCompleted,
  }) {
    return CalendarDay(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      learnedCardsIds: learnedCardsIds ?? this.learnedCardsIds,
      streakCompleted: streakCompleted ?? this.streakCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'date': date.millisecondsSinceEpoch,
      'learnedCardsIds': learnedCardsIds,
      'streakCompleted': streakCompleted,
    };
  }

  factory CalendarDay.fromMap(Map<String, dynamic> map) {
    return CalendarDay(
      uid: map['uid'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      learnedCardsIds:
          List<String>.from(map['learnedCardsIds'] as List<String>),
      streakCompleted: map['streakCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarDay.fromJson(String source) =>
      CalendarDay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [uid, date, learnedCardsIds, streakCompleted];
}
