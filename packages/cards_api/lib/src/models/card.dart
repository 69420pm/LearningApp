// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_api/src/models/file.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId:4)
class Card extends File implements Equatable {
  /// unique never changing id
  @HiveField(0)
  @override
  final String uid;

  /// to String formatted creation date
  @HiveField(1)
  final DateTime dateCreated;

  /// possibility to get asked when showing the back and hiding the front
  /// (helpful for vocab)
  @HiveField(2)
  final bool askCardsInverted;

  /// possibility to type answer with keyboard and for learning spelling
  /// of a word
  @HiveField(3)
  final bool typeAnswer;

  /// overall score of recall for this card, the higher the better
  /// ranges from 0 (really new) to 6 (really secure with this card)
  @HiveField(4)
  final int recallScore;

  /// date when the card should get learned again
  @HiveField(5)
  final DateTime dateToReview;

  // a list of all parent strings in order from closest to most far away parent
  @override
  @HiveField(6)
  final List<String> parents;
  Card({
    required this.uid,
    required this.dateCreated,
    required this.askCardsInverted,
    required this.typeAnswer,
    required this.recallScore,
    required this.dateToReview,
    required this.parents,
  }) : super(uid: uid, parents: parents);

  Card copyWith({
    String? uid,
    DateTime? dateCreated,
    bool? askCardsInverted,
    bool? typeAnswer,
    int? recallScore,
    DateTime? dateToReview,
    List<String>? parents,
  }) {
    return Card(
      uid: uid ?? this.uid,
      dateCreated: dateCreated ?? this.dateCreated,
      askCardsInverted: askCardsInverted ?? this.askCardsInverted,
      typeAnswer: typeAnswer ?? this.typeAnswer,
      recallScore: recallScore ?? this.recallScore,
      dateToReview: dateToReview ?? this.dateToReview,
      parents: parents ?? this.parents,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      uid,
      dateCreated,
      askCardsInverted,
      typeAnswer,
      recallScore,
      dateToReview,
      parents
    ];
  }
}
