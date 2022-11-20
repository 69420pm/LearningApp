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

  final List<Folder> childFolders;

  final List<Card> childCards;
  const Folder({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.parentId,
    required this.childFolders,
    required this.childCards,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      dateCreated,
      parentId,
      childFolders,
      childCards,
    ];
  }

  Folder copyWith({
    String? name,
    String? dateCreated,
    String? parentId,
    List<Folder>? childFolders,
    List<Card>? childCards,
  }) {
    return Folder(
      id: id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      parentId: parentId ?? this.parentId,
      childFolders: childFolders ?? this.childFolders,
      childCards: childCards ?? this.childCards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated,
      'parentId': parentId,
      'childFolders': childFolders.map((x) => x.toMap()).toList(),
      'childCards': childCards.map((x) => x.toMap()).toList(),
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated: map['dateCreated'] as String,
      parentId: map['parentId'] as String,
      childFolders: List.empty(growable: true),
      childCards: List.empty(growable: true),
    );
  }

  String toJson() => json.encode(toMap());

  factory Folder.fromJson(String source) =>
      Folder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
