// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_app/features/folder_system/data/models/card_model.dart';
import 'package:learning_app/features/folder_system/domain/entities/fileSystem.dart';

import 'file.dart';

class Card extends File implements FileSystem {
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime dateCreated;
  @override
  final DateTime lastChanged;
  final int recallScore;
  final DateTime dateToReview;
  final bool typeAnswer;
  final bool askCardsBothSided;
  const Card({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.lastChanged,
    required this.recallScore,
    required this.dateToReview,
    required this.typeAnswer,
    required this.askCardsBothSided,
  }) : super(
          id: id,
          name: name,
          dateCreated: dateCreated,
          lastChanged: lastChanged,
        );

  Card copyWith({
    String? id,
    String? name,
    DateTime? dateCreated,
    DateTime? lastChanged,
    int? recallScore,
    DateTime? dateToReview,
    bool? typeAnswer,
    bool? askCardsBothSided,
  }) {
    return Card(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      lastChanged: lastChanged ?? this.lastChanged,
      recallScore: recallScore ?? this.recallScore,
      dateToReview: dateToReview ?? this.dateToReview,
      typeAnswer: typeAnswer ?? this.typeAnswer,
      askCardsBothSided: askCardsBothSided ?? this.askCardsBothSided,
    );
  }

  @override
  String toString() {
    return 'Card(id: $id, name: $name, dateCreated: $dateCreated, lastChanged: $lastChanged, recallScore: $recallScore, dateToReview: $dateToReview, typeAnswer: $typeAnswer, askCardsBothSided: $askCardsBothSided)';
  }

  @override
  List<Object> get props => [
        id,
        name,
        dateCreated,
        lastChanged,
        recallScore,
        dateToReview,
        typeAnswer,
        askCardsBothSided
      ];

  @override
  CardModel toModel() {
    return CardModel(
        id: id,
        name: name,
        dateCreated: dateCreated,
        lastChanged: lastChanged,
        recallScore: recallScore,
        dateToReview: dateToReview,
        typeAnswer: typeAnswer,
        askCardsBothSided: askCardsBothSided);
  }
}
