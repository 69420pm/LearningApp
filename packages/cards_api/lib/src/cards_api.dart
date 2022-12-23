// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';

/// {@template cards_api}
/// The interface and models for an API providing access to cards.
/// {@endtemplate}
abstract class CardsApi {
  /// {@macro cards_api}
  const CardsApi();

  /// provide a [Stream] of all subjects
  Stream<List<Subject>> getSubjects();

  /// return all cards which should get learned
  List<Card> learnAllCards();

  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(Card card);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject);

  /// Saves a [folder]
  /// If a [folder] with same id already exists, it will be replaced
  Future<void> saveFolder(Folder folder);

  /// Deletes card with given id
  /// If no card with given id exists, a [CardNotFoundException] error is
  /// thrown
  Future<void> deleteCard(String id, String parentId);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is
  /// thrown
  Future<void> deleteSubject(String id);

  /// Deletes folder and every children with given id
  /// If no card with given id exists, a [FolderNotFoundException] error is
  /// thrown
  Future<void> deleteFolder(String id, String parentId);

  /// Move folder and every children to [newParentId]
  Future<void> moveFolder(Folder folder, String newParentId);

  /// return all children in stream to a given parentId
  Stream<List<Object>> getChildrenById(String id);

  /// close stream for given parentId to avoid stream leaks
  void closeStreamById(String id, {bool deleteChildren = false});
}

/// Error when a [Card] with given id is not found
class CardNotFoundException implements Exception {}

/// Error when a [Subject] with given id is not found
class SubjectNotFoundException implements Exception {}

/// Error when a [Folder] with given id is not found
class FolderNotFoundException implements Exception {}

/// Error when a parent ([Folder] or [Card]) doesn't exist
class ParentNotFoundException implements Exception {}

/// Error when a stream for a given parentId wasn't found
class StreamNotFoundException implements Exception {}
