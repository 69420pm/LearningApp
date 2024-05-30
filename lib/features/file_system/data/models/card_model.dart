import 'dart:convert';

import 'package:learning_app/features/file_system/domain/entities/card.dart';

class CardModel extends Card {
  CardModel(
      {required super.id,
      required super.name,
      required super.dateCreated,
      required super.lastChanged,
      required super.recallScore,
      required super.dateToReview,
      required super.typeAnswer,
      required super.askCardsBothSided});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'lastChanged': lastChanged.millisecondsSinceEpoch,
      'recallScore': recallScore,
      'dateToReview': dateToReview.millisecondsSinceEpoch,
      'typeAnswer': typeAnswer,
      'askCardsBothSided': askCardsBothSided,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      lastChanged:
          DateTime.fromMillisecondsSinceEpoch(map['lastChanged'] as int),
      recallScore: map['recallScore'] as int,
      dateToReview:
          DateTime.fromMillisecondsSinceEpoch(map['dateToReview'] as int),
      typeAnswer: map['typeAnswer'] as bool,
      askCardsBothSided: map['askCardsBothSided'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) =>
      CardModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
