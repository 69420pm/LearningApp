// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';

/// {@template cards_repository}
/// A Repository that handles everything related to cards, subjects and groups
/// {@endtemplate}
class CardsRepository {
  /// {@macro cards_repository}
  const CardsRepository({required CardsApi cardsApi}) : _cardsApi = cardsApi;

  final CardsApi _cardsApi;

  /// provide a [Stream] of all cards
  Stream<List<Group>> getCards() => _cardsApi.getCards();

  /// provide a [Stream] of all groups
  Stream<List<Group>> getGroups() => _cardsApi.getGroups();

  /// provide a [Stream] of all subjects
  Stream<List<Group>> getSubjects() => _cardsApi.getSubjects();


  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(Card card) => _cardsApi.saveCard(card);

  /// Saves a [group]
  /// If a [group] with same id already exists, it will be replaced
  Future<void> saveGroup(Group group) => _cardsApi.saveGroup(group);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject) => _cardsApi.saveSubject(subject);


  /// Deletes card with given id
  /// If no card with given id exists, a [CardNotFoundException] error is 
  /// thrown
  Future<void> deleteCard(String id) => _cardsApi.deleteCard(id);

  /// Deletes group and every children with given id
  /// If no card with given id exists, a [GroupNotFoundException] error is 
  /// thrown
  Future<void> deleteGroup(String id) => _cardsApi.deleteGroup(id);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is 
  /// thrown
  Future<void> deleteSubject(String id) => _cardsApi.deleteSubject(id);
}
