// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Group extends Equatable {
  /// unique never changing id
  final String id;
  /// possibly changing name
  final String name;
  /// to String formatted creation date
  final String dateCreated;
  const Group({
    required this.id,
    required this.name,
    required this.dateCreated,
  });

  Group copyWith({
    String? name,
    String? dateCreated,
  }) {
    return Group(
      // id can't be changed
      id: id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, dateCreated];
}
