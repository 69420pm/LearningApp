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
  List<Subject> _subjects = List.empty(growable: true);

  List<String> _indexedPaths = [];
  Map<String, BehaviorSubject<List<Object>>> _subscribedStreams = {};

  void _init() {
    try {
      _indexedPaths = _hiveBox.get('indexed_paths') as List<String>;
      print(_indexedPaths);
    } catch (e) {
      print("no paths saved");
    }
    try {
      final subjectJson = _hiveBox.get('/subjects') as List<String>;
      _subjects = _subjectsFromJson(subjectJson);
      _subjectStreamController.add(_subjects);
    } catch (e) {
      print('no subjects saved');
    }
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
  Future<void> deleteCard(String id, String parentId) async {
    final path = _getPath(parentId);
    if (path == null) {
      throw ParentNotFoundException();
    }

    final cards = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (cards != null) {
      for (final element in cards) {
        if (element.substring(7).startsWith(id)) {
          cards.remove(element);
          found = true;
          break;
        }
      }
    }
    if (found == false) {
      throw ParentNotFoundException();
    }
    if (_subscribedStreams.containsKey(parentId)) {
      _subscribedStreams[parentId]!.add([Removed(id: id)]);
    }
    return _hiveBox.put(path, cards);
  }

  @override
  Future<void> deleteSubject(String id) {
    // TODO: implement deleteSubject
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFolder(String id, String parentId) {
    final path = _getPath(parentId);
    if (path == null) {
      throw ParentNotFoundException();
    }
    final folders = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (folders != null) {
      for (final element in folders) {
        if (element.substring(7).startsWith(id)) {
          folders.remove(element);
          found = true;
          break;
        }
      }
    }
    if (found == false) {
      throw ParentNotFoundException();
    }
    if (_subscribedStreams.containsKey(parentId)) {
      _subscribedStreams[parentId]!.add([Removed(id: id)]);
    }
    _deleteChildPaths(id);
    return _hiveBox.put(path, folders);
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
    final newStream = BehaviorSubject<List<Object>>.seeded(const []);
    final path = _getPath(id);
    if(path == null) {
      throw StreamNotFoundException();
    }
    print(_hiveBox.get(path));
    final childrenStrings = _hiveBox.get(path) as List<String>?;
    final children = <Object>[];
    if (childrenStrings != null) {
      for (final element in childrenStrings) {
        try {
          children.add(_cardsFromJson([element])[0]);
        } catch (e) {}
        try {
          children.add(_foldersFromJson([element])[0]);
        } catch (e) {}
      }
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
        _subjects.indexWhere((element) => element.id == subject.id);
    if (subjectIndex >= 0) {
      _subjects[subjectIndex] = subject;
    } else {
      _subjects.add(subject);
    }
    _subjectStreamController.add(_subjects);
    _indexedPaths.add('/subjects/${subject.id}');
    _saveIndexedPaths();
    return _hiveBox.put('/subjects', _subjectsToJson(_subjects));
  }

  @override
  Future<void> saveFolder(Folder folder) {
    final parentId = folder.parentId;

    final path = _getPath(parentId);

    if (path == null) {
      throw ParentNotFoundException();
    }
    if (!_indexedPaths.contains('$path/${folder.id}')) {
      _indexedPaths.add('$path/${folder.id}');
      _saveIndexedPaths();
    }
    var folders = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (folders != null) {
      for (var element in folders) {
        if (element.substring(7).startsWith(folder.id)) {
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
      throw ParentNotFoundException();
    }
    var cards = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (cards != null) {
      for (var element in cards) {
        // contains word
        if (element.substring(7).startsWith(card.id)) {
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

  @override
  Future<void> moveCard(
      String id, String previousParentId, String newParentId) {
    throw UnimplementedError();
  }

  @override
  Future<void> moveFolder(Folder folder, String newParentId) async {
    final path = _getPath(folder.parentId);
    if (path == null) {
      throw ParentNotFoundException();
    }
    final folders = _hiveBox.get(path) as List<String>?;
    var found = false;
    if (folders != null) {
      for (final element in folders) {
        if (element.substring(7).startsWith(folder.id)) {
          folders.remove(element);
          found = true;
          break;
        }
      }
    }
    if (found == false) {
      throw ParentNotFoundException();
    }
    _hiveBox.put(folder.parentId, folders);
    if (_subscribedStreams.containsKey(folder.parentId)) {
      _subscribedStreams[folder.parentId]!.add([Removed(id: folder.id)]);
    }
    await _moveChildPaths(folder.id, newParentId);
    final newFolder = folder.copyWith(parentId: newParentId);
    await saveFolder(newFolder);
  }

  String? _getPath(String parentId) {
    for (final element in _indexedPaths) {
      if (element.endsWith(parentId)) {
        return element;
      }
    }
    return null;
  }

  Future<void> _deleteChildPaths(String id) {
    List<String> newIndexedPaths = [];
    for (final element in _indexedPaths) {
      if (element.contains(id)) {
        _hiveBox.delete(element);
      } else {
        newIndexedPaths.add(element);
      }
    }
    _indexedPaths = newIndexedPaths;
    return _saveIndexedPaths();
  }

  Future<void> _moveChildPaths(String oldId, String newId) async {
    final newPrefix = _getPath(newId);
    if (newPrefix == null) {
      throw ParentNotFoundException();
    }
    final newIndexPaths = <String>[];
    for (final element in _indexedPaths) {
      if (element.contains(oldId)) {
        final newPath =
            '$newPrefix/${element.substring(element.indexOf(oldId))}';
        newIndexPaths.add(newPath);
        final previousStoredObjects = _hiveBox.get(element) as List<String>?;
        if (previousStoredObjects != null) {
          await _hiveBox.delete(element);
          await _hiveBox.put(newPath, previousStoredObjects);
        }
      } else {
        newIndexPaths.add(element);
      }
    }
    _indexedPaths = newIndexPaths;
    return _saveIndexedPaths();
  }

  Future<void> _saveIndexedPaths() async {
    final newIndexPaths = _indexedPaths.toSet().toList();
    await _hiveBox.put('indexed_paths', newIndexPaths);
  }
}
