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

  final List<Folder> childFolders;

  final List<Card> childCards;

  final List<String> daysToGetNotified;
  final List<String> classTests;
  const Subject({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.prefixIcon,
    required this.childFolders,
    required this.childCards,
    required this.daysToGetNotified,
    required this.classTests,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      dateCreated,
      prefixIcon,
      childFolders,
      childCards,
      daysToGetNotified,
      classTests,
    ];
  }

  Subject copyWith({
    String? id,
    String? name,
    String? dateCreated,
    String? prefixIcon,
    List<Folder>? childFolders,
    List<Card>? childCards,
    List<String>? daysToGetNotified,
    List<String>? classTest,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      childFolders: childFolders ?? this.childFolders,
      childCards: childCards ?? this.childCards,
      daysToGetNotified: daysToGetNotified ?? this.daysToGetNotified,
      classTests: classTest ?? this.classTests,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'prefixIcon': prefixIcon,
      'daysToGetNotified': daysToGetNotified,
      'classTest': classTests,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
        id: map['id'] as String,
        name: map['name'] as String,
        dateCreated: map['dateCreated'] as String,
        prefixIcon: map['prefixIcon'] as String,
        childFolders: List.empty(growable: true),
        childCards: List.empty(growable: true),
        daysToGetNotified:
            List<String>.from(map['daysToGetNotified'] as List<dynamic>),
        classTests: List<String>.from(
          (map['classTest'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
