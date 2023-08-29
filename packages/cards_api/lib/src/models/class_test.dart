// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassTest extends Equatable {
  final String id;
  final String name;
  final String date;
  final List<String> folderIds;
  const ClassTest({
    required this.id,
    required this.name,
    required this.date,
    required this.folderIds,
  });

  ClassTest copyWith({
    String? id,
    String? name,
    String? date,
    List<String>? folderIds,
  }) {
    return ClassTest(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      folderIds: folderIds ?? this.folderIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'date': date,
      'folderIds': folderIds,
    };
  }

  factory ClassTest.fromMap(Map<String, dynamic> map) {
    return ClassTest(
      id: map['id'] as String,
      name: map['name'] as String,
      date: map['date'] as String,
      folderIds: List<String>.from(
        map['folderIds'] as List<String>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassTest.fromJson(String source) =>
      ClassTest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, date, folderIds];
}
