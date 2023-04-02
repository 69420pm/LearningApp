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

  /// provide a [Stream] of all subjects
  Stream<List<Subject>> getSubjects() => _cardsApi.getSubjects();

  /// return all cards to learn
  List<Card> learnAllCards() => _cardsApi.learnAllCards();

  List<Card> search(String searchRequest) => _cardsApi.search(searchRequest);

  /// return all children for a given parentId in a stream
  Stream<List<Object>> getChildrenById(String id) =>
      _cardsApi.getChildrenById(id);

  /// Close stream for a given parentId to avoid stream leaks
  Future<void> closeStreamById(String id, {bool deleteChildren = false}) =>
      _cardsApi.closeStreamById(id, deleteChildren: deleteChildren);

  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(Card card) => _cardsApi.saveCard(card);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject) => _cardsApi.saveSubject(subject);

  /// Saves a [folder]
  /// If a [folder] with same id already exists it will get replaced
  Future<void> saveFolder(Folder folder) => _cardsApi.saveFolder(folder);

  /// Deletes card with given id
  /// If no card with given id exists, a [CardNotFoundException] error is
  /// thrown
  Future<void> deleteCard(String id, String parentId) =>
      _cardsApi.deleteCard(id, parentId);

  Future<void> deleteCards(List<String> ids, List<String> parentIds) =>
      _cardsApi.deleteCards(ids, parentIds);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is
  /// thrown
  Future<void> deleteSubject(String id) => _cardsApi.deleteSubject(id);

  /// Delete subject and every children inheriting from it
  Future<void> deleteFolder(String id, String parentId) =>
      _cardsApi.deleteFolder(id, parentId);

  /// Move folder and every children to [newParentId]
  Future<void> moveFolder(Folder folder, String newParentId) =>
      _cardsApi.moveFolder(folder, newParentId);

  Future<void> moveCards(List<Card> cards, String newParentId) =>
    _cardsApi.moveCards(cards, newParentId);
}
