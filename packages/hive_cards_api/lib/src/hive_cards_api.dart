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

  // Map<String, BehaviorSubject<List<Object>>> as = {};

  /// MAYBE USE MAPS ???
  List<Card> cards = List.empty(growable: true);
  List<Folder> folders = List.empty(growable: true);
  List<Subject> subjects = List.empty(growable: true);

  List<String> _indexedPaths = [];
  Map<String, BehaviorSubject<List<Object>>> _subscribedStreams =
      Map.identity();

  void _init() {
    try {
      _indexedPaths = _hiveBox.get('indexed_paths') as List<String>;
    } catch (e) {
      print("no paths saved");
    }
  }

  // void _init() {
  //   try {
  //     var jsonCards = _hiveBox.get('cards') as List<String>;
  //     cards = _cardsFromJson(jsonCards);
  //     _cardStreamController.add(cards);

  //   } catch (e) {
  //     var text = 'no cards on hive db saved';
  //   }

  //   try {
  //     var jsonFolders = _hiveBox.get('folders') as List<String>;
  //     folders = _foldersFromJson(jsonFolders);
  //     _folderStreamController.add(folders);

  //   } catch (e) {
  //     var text = 'no folders on hive db saved';
  //   }

  //   try {
  //     final jsonSubjects = _hiveBox.get('subjects') as List<String>;
  //     subjects = _subjectsFromJson(jsonSubjects);
  //     _subjectStreamController.add(subjects);
  //   } catch (e) {
  //     var text = 'no subjects on hive db saved';
  //   }

  //   folders.forEach((folder) {
  //     subjects.forEach((subject) {
  //       if(folder.parentId == subject.id){
  //         subject.childFolders.add(folder);
  //       }
  //      });
  //     folders.forEach((folder) {
  //       if(folder.parentId == folder.id){
  //         folder.childFolders.add(folder);
  //       }
  //     });
  //   });    /// SHOULD GET OPTIMIZED
  //   cards.forEach((card) {
  //     subjects.forEach((subject) {
  //       if(card.parentId == subject.id){
  //         subject.childCards.add(card);
  //       }
  //      });
  //     folders.forEach((folder) {
  //       if(card.parentId == folder.id){
  //         folder.childCards.add(card);
  //       }
  //     });
  //   });
  //   _subjectStreamController.add(subjects);
  //   // for (var subject in subjects) {
  //   //   for (var cards in subject.childCardIds) {
  //   //     if (cardsMap[cards] != null) {
  //   //       subject.childCards.add(cardsMap[cards]!);
  //   //     } else {

  //   //     }
  //   //   }
  //   //   for (var element in subject.childFolderIds) {}
  //   // }
  // }

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
  Stream<List<Object>> getChildrenById(String id) {
    // if (_subscribedStreams[id] != null) {
    //   return _subscribedStreams[id]!.asBroadcastStream();
    // }
    print(_subscribedStreams);
    final newStream = BehaviorSubject<List<Object>>.seeded(const []);
    final path = _getPath(id);
    final childrenStrings = _hiveBox.get(path) as List<String>?;
    final children = <Object>[];
    if (childrenStrings != null) {
      childrenStrings.forEach((element) {
        try {
          children.add(_cardsFromJson([element])[0]);
        } catch (e) {}
        try {
          children.add(_foldersFromJson([element])[0]);
        } catch (e) {}
      });
    }

    newStream.add(children);
    _subscribedStreams[id] = newStream;
    return newStream;
  }

  @override
  void closeStreamById(String id) {
    if (_subscribedStreams[id] != null) {
      _subscribedStreams[id]!.close();
      _subscribedStreams.remove(id);
    }
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
    _indexedPaths.add("/subjects/" + subject.id);
    _saveIndexedPaths();
    return _hiveBox.put('/subjects', _subjectsToJson(subjects));
  }

  @override
  Future<void> saveFolder(Folder folder) {
    final parentId = folder.parentId;

    final path = _getPath(parentId);

    if (path == null) {
      throw ParentNotFoundException;
    }
    if (!_indexedPaths.contains(path + '/' + folder.id)) {
      _indexedPaths.add(path + '/' + folder.id);
      _saveIndexedPaths();
    }
    var folders = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (folders != null) {
      for (var element in folders) {
        if (element.substring(8).startsWith(folder.id)) {                                      
          element = _foldersToJson([folder])[0];
          found = true;
          break;
        }
      }
    } else {
      folders = [];
    }

    if (!found) {
      folders.add(_foldersToJson([folder])[0]);
    }

    if (_subscribedStreams.containsKey(parentId)) {
      _subscribedStreams[parentId]!.add([folder]);
    }

    return _hiveBox.put(path, folders);
  }

  @override
  Future<void> saveCard(Card card) {
    final parentId = card.parentId;

    final path = _getPath(parentId);

    if (path == null) {
      throw ParentNotFoundException;
    }
    var cards = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (cards != null) {
      for (var element in cards) {
        // contains word
        if (element.substring(8).startsWith(card.id)) {
          element = _cardsToJson([card])[0];
          found = true;
          break;
        }
      }
    } else {
      cards = [];
    }

    if (!found) {
      cards.add(_cardsToJson([card])[0]);
    }

    if (_subscribedStreams.containsKey(parentId)) {
      _subscribedStreams[parentId]!.add([card]);
    }

    return _hiveBox.put(path, cards);
  }

  String? _getPath(String parentId) {
    for (var element in _indexedPaths) {
      if (element.endsWith(parentId)) {
        return element;
      }
    }
    return null;
  }

  void _saveIndexedPaths() {
    _hiveBox.put('indexed_paths', _indexedPaths);
  }
}
