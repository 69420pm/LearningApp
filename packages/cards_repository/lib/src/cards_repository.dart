// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
/// {@template cards_repository}
/// A Repository that handles everything related to cards, subjects and groups
/// {@endtemplate}
class CardsRepository {
  /// {@macro cards_repository}
  const CardsRepository({required CardsApi cardsApi}) : _cardsApi = cardsApi;

  final CardsApi _cardsApi;

  /// provide a [Stream] of all subjects
  ValueListenable<Box<Subject>> getSubjects() => _cardsApi.getSubjects();

  /// return all cards to learn
  List<Card> learnAllCards() => _cardsApi.learnAllCards();

  /// search request to search in all cards, give parent[id] only search 
  /// everything saved in this id or below, e.g. when only searched all 
  /// subject contents, give subject id
  List<SearchResult> searchCard(String searchRequest, String? id) =>
      _cardsApi.searchCard(searchRequest, id);

  /// search request to search in all subjects
  List<Subject> searchSubject(String searchRequest) =>
      _cardsApi.searchSubject(searchRequest);

  /// search request to search in all folders, give parent[id] only search 
  /// everything saved in this id or below, e.g. when only searched all 
  /// subject contents, give subject id
  List<SearchResult> searchFolder(String searchRequest, String? id) =>
      _cardsApi.searchFolder(searchRequest, id);

  /// return all children for a given parentId in a stream
  ValueNotifier<List<File>> getChildrenById(String id) =>
      _cardsApi.getChildrenById(id);

  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(Card card, String? parentId) => _cardsApi.saveCard(card, parentId);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject) => _cardsApi.saveSubject(subject);

  /// Saves a [folder]
  /// If a [folder] with same id already exists it will get replaced
  Future<void> saveFolder(Folder folder, String? parentId) => _cardsApi.saveFolder(folder, parentId);

  /// Deletes card with given id
  /// If no card with given id exists, a [CardNotFoundException] error is
  /// thrown
  Future<void> deleteCards(List<String> id) =>
      _cardsApi.deleteCards(id);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is
  /// thrown
  Future<void> deleteSubject(String id) => _cardsApi.deleteSubject(id);

  /// Delete subject and every children inheriting from it
  Future<void> deleteFolders(List<String> id) =>
      _cardsApi.deleteFolders(id);

  /// Move folder and every children to [newParentId]
  Future<void> moveFolders(List<Folder> folder, String newParentId) =>
      _cardsApi.moveFolders(folder, newParentId);

  // Move cards
  Future<void> moveCards(List<Card> cards, String newParentId) =>
      _cardsApi.moveCards(cards, newParentId);

  // get list of every children for a given parentId
  List<String> getChildrenlist(String parentId) => _cardsApi.getChildrenList(parentId);

  // get parent id to a given child id
  String getParentIdFromChildId(String id) => _cardsApi.getParentIdFromChildId(id);
}
