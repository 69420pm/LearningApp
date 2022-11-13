// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:cards_api/cards_api.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

/// {@template hive_cards_api}
/// A Flutter implementation of the CardsApi that uses the hive database.
/// {@endtemplate}
class HiveCardsApi extends CardsApi {
  /// {@macro hive_cards_api}
  HiveCardsApi(this._hiveBox) {
    _init();
  }

  Box<dynamic> _hiveBox;

  final _cardStreamController = BehaviorSubject<List<Card>>.seeded(const []);
  final _subjectStreamController =
      BehaviorSubject<List<Subject>>.seeded(const []);

  void _init() {
    try {
      var jsonCards = _hiveBox.get('cards') as List<String>;
      _cardStreamController.add(_cardsFromJson(jsonCards));
    } catch (e) {
      var text = 'no cards on hive db saved';
      print('\x1B[33m$text\x1B[0m');
    }

    try {
      var jsonSubjects = _hiveBox.get('subjects') as List<String>;
      _subjectStreamController.add(_subjectsFromJson(jsonSubjects));
    } catch (e) {
      var text = 'no subjects on hive db saved';
      print('\x1B[33m$text\x1B[0m');
    }
  }

  List<String> _cardsToJson(List<Card> cards) {
    List<String> jsonCards = [];
    cards.forEach((element) {
      jsonCards.add(element.toJson());
    });
    return jsonCards;
  }

  List<String> _subjectsToJson(List<Subject> cards) {
    List<String> jsonSubjects = [];
    cards.forEach((element) {
      jsonSubjects.add(element.toJson());
    });
    return jsonSubjects;
  }

  List<Card> _cardsFromJson(List<String> json) {
    List<Card> cards = [];
    json.forEach((element) {
      cards.add(Card.fromJson(element));
    });
    return cards;
  }

  List<Subject> _subjectsFromJson(List<String> json) {
    List<Subject> subjects = List.empty(growable: true);
    json.forEach((element) {
      subjects.add(Subject.fromJson(element));
    });
    return subjects;
  }

  @override
  Future<void> deleteCard(String id) {
    // TODO: implement deleteCard
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSubject(String id) {
    // TODO: implement deleteSubject
    throw UnimplementedError();
  }

  @override
  Stream<List<Card>> getCards() {
    // TODO: implement getCards
    throw UnimplementedError();
  }

  @override
  Stream<List<Subject>> getSubjects() =>
      _subjectStreamController.asBroadcastStream();

  @override
  Future<void> saveCard(Card card) {
    final cards = [..._cardStreamController.value];
    final cardIndex = cards.indexWhere((element) => element.id == card.id);
    if (cardIndex >= 0) {
      cards[cardIndex] = card;
    } else {
      cards.add(card);
    }
    _cardStreamController.add(cards);

    return _hiveBox.put('cards', _cardsToJson(cards));
  }

  @override
  Future<void> saveSubject(Subject subject) {
    final subjects = [..._subjectStreamController.value];
    final subjectIndex =
        subjects.indexWhere((element) => element.id == subject.id);
    if (subjectIndex >= 0) {
      subjects[subjectIndex] = subject;
    } else {
      subjects.add(subject);
    }
    _subjectStreamController.add(subjects);

    return _hiveBox.put('subjects', _subjectsToJson(subjects));
  }
}
