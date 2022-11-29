// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cards_api/src/models/card.dart';
import 'package:equatable/equatable.dart';

class Folder extends Equatable {
  /// unique never changing id
  final String id;

  /// possibly changing name
  final String name;

  /// to String formatted creation date
  final String dateCreated;

  /// id of parent subject to order cards
  final String parentId;
  const Folder({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.parentId,
  });

  Folder copyWith({
    String? id,
    String? name,
    String? dateCreated,
    String? parentId,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'parentId': parentId,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
      parentId: map['parentId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Folder.fromJson(String source) =>
      Folder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, dateCreated, parentId];
}
