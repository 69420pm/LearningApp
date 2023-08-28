// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cards_api/cards_api.dart';
import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  /// unique never changing id
  final String id;

  /// possibly changing name
  final String name;

  /// to String formatted creation date
  final String dateCreated;

  /// prefix icon
  final String prefixIcon;

  /// days on which subject is scheduled
  final List<bool> daysToGetNotified;

  /// jsons of class tests
  final List<ClassTest> classTests;

  /// whether the subject should get considered for streak
  final bool streakRelevant;

  /// whether this subject is disabled
  final bool disabled;
  const Subject({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.prefixIcon,
    required this.daysToGetNotified,
    required this.classTests,
    required this.streakRelevant,
    required this.disabled,
  });
 

  Subject copyWith({
    String? id,
    String? name,
    String? dateCreated,
    String? prefixIcon,
    List<bool>? daysToGetNotified,
    List<ClassTest>? classTests,
    bool? streakRelevant,
    bool? disabled,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      daysToGetNotified: daysToGetNotified ?? this.daysToGetNotified,
      classTests: classTests ?? this.classTests,
      streakRelevant: streakRelevant ?? this.streakRelevant,
      disabled: disabled ?? this.disabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'prefixIcon': prefixIcon,
      'daysToGetNotified': daysToGetNotified,
      'classTests': classTests.map((x) => x.toMap()).toList(),
      'streakRelevant': streakRelevant,
      'disabled': disabled,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
      prefixIcon: map['prefixIcon'] as String,
      daysToGetNotified: List<bool>.from(map['daysToGetNotified'] as List<bool>),
      classTests: List<ClassTest>.from((map['classTests'] as List<int>).map<ClassTest>((x) => ClassTest.fromMap(x as Map<String,dynamic>),),),
      streakRelevant: map['streakRelevant'] as bool,
      disabled: map['disabled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      dateCreated,
      prefixIcon,
      daysToGetNotified,
      classTests,
      streakRelevant,
      disabled,
    ];
  }
}
