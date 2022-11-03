// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

/// {@template hive_cards_api}
/// A Flutter implementation of the CardsApi that uses the hive database.
/// {@endtemplate}
class HiveCardsApi extends CardsApi {
  /// {@macro hive_cards_api}
  HiveCardsApi(this._hiveBox);

  Box<dynamic> _hiveBox;

  final _cardStreamController = BehaviorSubject<List<Card>>.seeded(const []);
  final _subjectStreamController =
      BehaviorSubject<List<Subject>>.seeded(const []);
  final _groupStreamController = BehaviorSubject<List<Group>>.seeded(const []);

  void _init() {
    List<String>? _jsonCards = _hiveBox.get('cards') as List<String>;
    if (_jsonCards != null) {
      _cardStreamController.add(_cardsFromJson(_jsonCards));
    }
  }

  List<String> _cardsToJson(List<Card> cards) {
    List<String> jsonCards = [];
    cards.forEach((element) {
      jsonCards.add(element.toJson());
    });
    return jsonCards;
  }

  List<String> _groupsToJson(List<Group> cards) {
    List<String> jsonGroups = [];
    cards.forEach((element) {
      jsonGroups.add(element.toJson());
    });
    return jsonGroups;
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

  List<Group> _groupsFromJson(List<String> json) {
    List<Group> groups = [];
    json.forEach((element) {
      groups.add(Group.fromJson(element));
    });
    return groups;
  }

  List<Subject> _subjectsFromJson(List<String> json) {
    List<Subject> subjects = [];
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
  Future<void> deleteGroup(String id) {
    // TODO: implement deleteGroup
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSubject(String id) {
    // TODO: implement deleteSubject
    throw UnimplementedError();
  }

  @override
  Stream<List<Group>> getCards() {
    // TODO: implement getCards
    throw UnimplementedError();
  }

  @override
  Stream<List<Group>> getGroups() {
    // TODO: implement getGroups
    throw UnimplementedError();
  }

  @override
  Stream<List<Group>> getSubjects() {
    // TODO: implement getSubjects
    throw UnimplementedError();
  }

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

    return _hiveBox.put("cards", _cardsToJson(cards));
  }

  @override
  Future<void> saveGroup(Group group) {
    // TODO: implement saveGroup
    throw UnimplementedError();
  }

  @override
  Future<void> saveSubject(Subject subject) {
    // TODO: implement saveSubject
    throw UnimplementedError();
  }
}
