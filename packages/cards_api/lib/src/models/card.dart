// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Card extends Equatable {
  /// unique never changing id
  final String id;

  /// front of card
  final String front;

  /// back of card, which user should learn
  final String back;

  /// to String formatted creation date
  final String dateCreated;

  /// id of parent subject/group to order subjects
  final String parentId;

  /// possibility to get asked when showing the back and hiding the front
  /// (helpful for vocab)
  final bool askCardsInverted;

  /// possibility to type answer with keyboard and for learning spelling
  /// of a word
  final bool typeAnswer;

  /// overall score of recall for this card, the higher the better
  /// ranges from 0 (really new) to 6 (really secure with this card)
  final int recallScore;

  final List<String> tags;

  /// date when the card should get reviewed
  final String dateToReview;
  const Card({
    required this.id,
    required this.front,
    required this.back,
    required this.dateCreated,
    required this.parentId,
    required this.askCardsInverted,
    required this.typeAnswer,
    this.recallScore = 0,
    required this.tags,
    required this.dateToReview,
  });

  Card copyWith({
    String? front,
    String? back,
    String? dateCreated,
    String? parentId,
    bool? askCardsInverted,
    bool? typeAnswer,
    int? recallScore,
    List<String>? tags,
    String? dateToReview,
  }) {
    return Card(
      id: id,
      front: front ?? this.front,
      back: back ?? this.back,
      dateCreated: dateCreated ?? this.dateCreated,
      parentId: parentId ?? this.parentId,
      askCardsInverted: askCardsInverted ?? this.askCardsInverted,
      typeAnswer: typeAnswer ?? this.typeAnswer,
      recallScore: recallScore ?? this.recallScore,
      tags: tags ?? this.tags,
      dateToReview: dateToReview ?? this.dateToReview,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'front': front,
      'back': back,
      'dateCreated': dateCreated,
      'parentId': parentId,
      'askCardsInverted': askCardsInverted,
      'typeAnswer': typeAnswer,
      'recallScore': recallScore,
      'tags': tags,
      'dateToReview': dateToReview,
    };
  }

  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'] as String,
      front: map['front'] as String,
      back: map['back'] as String,
      dateCreated: map['dateCreated'] as String,
      parentId: map['parentId'] as String,
      askCardsInverted: map['askCardsInverted'] as bool,
      typeAnswer: map['typeAnswer'] as bool,
      recallScore: map['recallScore'] as int,
      tags: const [],
      /*List<String>.from(map['tags'] as List<String>)*/ //map.entries.map((e) => e.toString()).toList(),
      dateToReview: map['dateToReview'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Card.fromJson(String source) =>
      Card.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      front,
      back,
      dateCreated,
      parentId,
      askCardsInverted,
      typeAnswer,
      recallScore,
      tags,
      dateToReview,
    ];
  }
}
