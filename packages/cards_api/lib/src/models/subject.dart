// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cards_api/src/models/card.dart';
import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  /// unique never changing id
  final String id;

  /// possibly changing name
  final String name;

  /// to String formatted creation date
  final String dateCreated;

  /// id of parent subject to order cards
  final String? parentSubjectId;

  /// prefix icon
  final String prefixIcon;

  /// list of String dates as class tests
  final List<String> classTests;

  /// days user should get notified for this subject
  final List<String> daysToGetNotified;

  const Subject({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.parentSubjectId,
    required this.prefixIcon,
    required this.classTests,
    required this.daysToGetNotified,
  });

  Subject copyWith({
    String? name,
    String? dateCreated,
    String? parentSubjectId,
    String? prefixIcon,
    List<String>? classTests,
    List<String>? daysToGetNotified,
  }) {
    return Subject(
      // id can't be changed
      id: id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      parentSubjectId: parentSubjectId ?? this.parentSubjectId,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      classTests: classTests ?? this.classTests,
      daysToGetNotified: daysToGetNotified ?? this.daysToGetNotified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'parentSubjectId': parentSubjectId,
      'prefixIcon': prefixIcon,
      'classTests': classTests,
      'daysToGetNotified': daysToGetNotified,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
      parentSubjectId: map['parentSubjectId'] as String,
      prefixIcon: map['prefixIcon'] as String,
      classTests: List<String>.from(map['classTests'] as List<dynamic>),
      daysToGetNotified:
          List<String>.from(map['daysToGetNotified'] as List<dynamic>),    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      dateCreated,
      prefixIcon,
      classTests,
      daysToGetNotified,
    ];
  }
}
