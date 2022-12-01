// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cards_api/cards_api.dart';
import 'package:cards_api/src/models/card.dart';
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

  final List<String> daysToGetNotified;
  final List<String> classTests;



  const Subject({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.prefixIcon,
    required this.daysToGetNotified,
    required this.classTests,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? dateCreated,
    String? prefixIcon,
    List<String>? daysToGetNotified,
    List<String>? classTests,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      daysToGetNotified: daysToGetNotified ?? this.daysToGetNotified,
      classTests: classTests ?? this.classTests,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'prefixIcon': prefixIcon,
      'daysToGetNotified': daysToGetNotified,
      'classTests': classTests,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
      prefixIcon: map['prefixIcon'] as String,
      daysToGetNotified:
          List<String>.from(map['daysToGetNotified'] as List<String>),
      classTests: List<String>.from(map['classTests'] as List<String>),
    );
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
      daysToGetNotified,
      classTests,
    ];
  }
}
