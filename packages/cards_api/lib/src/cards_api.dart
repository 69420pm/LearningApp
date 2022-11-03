// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/src/models/card.dart';
import 'package:cards_api/src/models/group.dart';
import 'package:cards_api/src/models/subject.dart';

/// {@template cards_api}
/// The interface and models for an API providing access to cards.
/// {@endtemplate}
abstract class CardsApi {
  /// {@macro cards_api}
  const CardsApi();

  /// provide a [Stream] of all cards
  Stream<List<Group>> getCards();

  /// provide a [Stream] of all groups
  Stream<List<Group>> getGroups();

  /// provide a [Stream] of all subjects
  Stream<List<Group>> getSubjects();


  /// Saves a [card]
  /// If a [card] with same id already exists, it will be replaced
  Future<void> saveCard(Card card);

  /// Saves a [group]
  /// If a [group] with same id already exists, it will be replaced
  Future<void> saveGroup(Group group);

  /// Saves a [subject]
  /// If a [subject] with same id already exists, it will be replaced
  Future<void> saveSubject(Subject subject);


  /// Deletes card with given id
  /// If no card with given id exists, a [CardNotFoundException] error is 
  /// thrown
  Future<void> deleteCard(String id);

  /// Deletes group and every children with given id
  /// If no card with given id exists, a [GroupNotFoundException] error is 
  /// thrown
  Future<void> deleteGroup(String id);

  /// Deletes subject and every children with given id
  /// If no card with given id exists, a [SubjectNotFoundException] error is 
  /// thrown
  Future<void> deleteSubject(String id);
}

/// Error when a [Card] with given id is not found
class CardNotFoundException implements Exception {}

/// Error when a [Group] with given id is not found
class GroupNotFoundException implements Exception {}

/// Error when a [Subject] with given id is not found
class SubjectNotFoundException implements Exception {}
