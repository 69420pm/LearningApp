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
  final _folderStreamController =
      BehaviorSubject<List<Folder>>.seeded(const []);
  final _subjectStreamController =
      BehaviorSubject<List<Subject>>.seeded(const []);

  /// MAYBE USE MAPS ???
  List<Card> cards = List.empty(growable: true);
  List<Folder> folders = List.empty(growable: true);
  List<Subject> subjects = List.empty(growable: true);

  void _init() {
    try {
      var jsonCards = _hiveBox.get('cards') as List<String>;
      cards = _cardsFromJson(jsonCards);
      _cardStreamController.add(cards);


    } catch (e) {
      var text = 'no cards on hive db saved';
    }

    try {
      var jsonFolders = _hiveBox.get('folders') as List<String>;
      folders = _foldersFromJson(jsonFolders);
      _folderStreamController.add(folders);

    } catch (e) {
      var text = 'no folders on hive db saved';
    }

    try {
      final jsonSubjects = _hiveBox.get('subjects') as List<String>;
      subjects = _subjectsFromJson(jsonSubjects);
      _subjectStreamController.add(subjects);
    } catch (e) {
      var text = 'no subjects on hive db saved';
    }

    folders.forEach((folder) {
      subjects.forEach((subject) {
        if(folder.parentId == subject.id){
          subject.childFolders.add(folder);
        }
       });
      folders.forEach((folder) { 
        if(folder.parentId == folder.id){
          folder.childFolders.add(folder);
        }
      });
    });    /// SHOULD GET OPTIMIZED
    cards.forEach((card) {
      subjects.forEach((subject) {
        if(card.parentId == subject.id){
          subject.childCards.add(card);
        }
       });
      folders.forEach((folder) { 
        if(card.parentId == folder.id){
          folder.childCards.add(card);
        }
      });
    });
    _subjectStreamController.add(subjects);
    // for (var subject in subjects) {
    //   for (var cards in subject.childCardIds) {
    //     if (cardsMap[cards] != null) {
    //       subject.childCards.add(cardsMap[cards]!);
    //     } else {
          
    //     }
    //   }
    //   for (var element in subject.childFolderIds) {}
    // }
  }

  List<String> _cardsToJson(List<Card> cards) {
    List<String> jsonCards = [];
    for (var element in cards) {
      jsonCards.add(element.toJson());
    }
    return jsonCards;
  }

  List<String> _foldersToJson(List<Folder> folders) {
    List<String> jsonFolders = [];
    for (var element in folders) {
      jsonFolders.add(element.toJson());
    }
    return jsonFolders;
  }

  List<String> _subjectsToJson(List<Subject> cards) {
    List<String> jsonSubjects = [];
    for (var element in cards) {
      jsonSubjects.add(element.toJson());
    }
    return jsonSubjects;
  }

  List<Card> _cardsFromJson(List<String> json) {
    List<Card> cards = [];
    for (var element in json) {
      cards.add(Card.fromJson(element));
    }
    return cards;
  }

  List<Folder> _foldersFromJson(List<String> json) {
    List<Folder> folders = [];
    for (var element in json) {
      folders.add(Folder.fromJson(element));
    }
    return folders;
  }

  List<Subject> _subjectsFromJson(List<String> json) {
    List<Subject> subjects = List.empty(growable: true);
    for (var element in json) {
      subjects.add(Subject.fromJson(element));
    }
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
  Future<void> deleteFolder(String id) {
    // TODO: implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Stream<List<Card>> getCards() => _cardStreamController.asBroadcastStream();

  Stream<List<Folder>> getFolders() =>
      _folderStreamController.asBroadcastStream();

  @override
  Stream<List<Subject>> getSubjects() =>
      _subjectStreamController.asBroadcastStream();

  @override
  Future<void> saveCard(Card card) {
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

  @override
  Future<void> saveFolder(Folder folder) {
    final folderIndex =
        folders.indexWhere((element) => element.id == folder.id);
    if (folderIndex >= 0) {
      folders[folderIndex] = folder;
    } else {
      folders.add(folder);
    }
    _folderStreamController.add(folders);
    return _hiveBox.put('folders', _foldersToJson(folders));
  }
}
