// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:cards_api/cards_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// {@template hive_cards_api}
/// A Flutter implementation of the CardsApi that uses the hive database.
/// {@endtemplate}
class HiveCardsApi extends CardsApi {
  /// {@macro hive_cards_api}
  HiveCardsApi(
    this._subjectBox,
    this._folderBox,
    this._cardBox,
    this._relationsBox,
  ) {
    _init();
  }

  final Box<Subject> _subjectBox;
  final Box<Folder> _folderBox;
  final Box<Card> _cardBox;
  final Box<List<String>> _relationsBox;
  // final Box<CardContent> _cardContentBox;

  final Map<String, ValueNotifier<List<File>>> _notifiers = {};
  ValueListenable<Box<Subject>>? _subjectStreamController;
  void _init() {
    // load all saved subjects
    try {
      _subjectStreamController = _subjectBox.listenable();
    } catch (e) {
      log('\x1B[32m error with subjects\x1B[32m');
    }
  }

  @override
  List<Card> learnAllCards() {
    // TODO: implement learnAllCards
    throw UnimplementedError();
  }

  @override
  ValueListenable<Box<Subject>> getSubjects() {
    if (_subjectStreamController != null) {
      return _subjectStreamController!;
    } else {
      throw SubjectNotFoundException();
    }
  }

  @override
  ValueNotifier<List<File>> getChildrenById(String id) {
    final childrenIds = _relationsBox.get(id);
    final children = <File>[];
    ValueNotifier<List<File>> valueNotifier;
    if (_notifiers[id] != null) {
      valueNotifier = _notifiers[id]!;
    } else {
      valueNotifier = ValueNotifier<List<File>>([]);
      _notifiers[id] = valueNotifier;
    }

    if (childrenIds == null) {
      return valueNotifier;
    }
    for (final id in childrenIds) {
      final card = _cardBox.get(id);
      if (card == null) {
        final folder = _folderBox.get(id);
        if (folder != null) {
          children.add(folder);
        } else {
          throw FolderNotFoundException();
        }
      }
    }
    valueNotifier.value = children;
    return valueNotifier;
  }

  @override
  Folder? getFolderById(String folderUID) {
    return _folderBox.get(folderUID);
  }

  @override
  Future<void> saveSubject(Subject subject) async {
    await _subjectBox.put(subject.uid, subject);
  }

  @override
  Future<void> saveFolder(Folder folder, String? parentId_) async {
    final parentId = parentId_ ?? getParentIdFromChildId(folder.uid);
    // add folder to _folderBox
    await _folderBox.put(folder.uid, folder);
    // add folder to relations
    final relations = _relationsBox.get(parentId);
    if (relations == null) {
      await _relationsBox.put(parentId, [folder.uid]);
    } else {
      relations.add(folder.uid);
      await _relationsBox.put(parentId, relations);
    }
    // update notifiers
    final currentNotifier = _notifiers[parentId];
    if (currentNotifier != null) {
      final children = currentNotifier.value;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        if (child.uid == folder.uid) {
          children[i] = folder;
          currentNotifier.value = List.from(children);
          return;
        }
      }
      children.add(folder);
      currentNotifier.value = List.from(children);
    }
  }

  @override
  Future<void> saveCard(Card card, String? parentId_) async {
    final parentId = parentId_ ?? getParentIdFromChildId(card.uid);
    // add card to _cardBox
    await _cardBox.put(card.uid, card);

    // add card to relations
    final relations = _relationsBox.get(parentId);
    if (relations != null) {
      await _relationsBox.put(parentId, [card.uid]);
    } else {
      relations!.add(card.uid);
      await _relationsBox.put(parentId, relations);
    }

    // update notifiers
    final currentNotifier = _notifiers[parentId];
    if (currentNotifier != null) {
      final children = currentNotifier.value;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        if (child.uid == card.uid) {
          children[i] = card;
          currentNotifier.value = List.from(children);
          return;
        }
      }
      children.add(card);
      currentNotifier.value = List.from(children);
    }
  }

  @override
  Future<void> deleteSubject(String id) async {
    await _subjectBox.delete(id);
    final children = getChildrenList(id);
    await _deleteFolders(children, false);
  }

  @override
  Future<void> deleteFolders(List<String> ids) async {
    await _deleteFolders(ids, true);
  }

  @override
  Future<void> deleteCards(List<String> ids) async {
    for (final id in ids) {
      final parentId = getParentIdFromChildId(id);
      await _cardBox.delete(id);
      // remove card from parent relation entry
      final currentRelationEntry = _relationsBox.get(parentId);
      if (currentRelationEntry != null) {
        currentRelationEntry.remove(id);
        await _relationsBox.put(parentId, currentRelationEntry);
      }
      // remove folder from _notifier
      final currentNotifier = _notifiers[parentId];
      if (currentNotifier != null) {
        final children = currentNotifier.value..remove(_cardBox.get(id));
        currentNotifier.value = List.from(children);
      }
    }
  }

  @override
  Future<void> moveFolders(List<Folder> folders, String newParentId) async {
    var newRelationEntry = _relationsBox.get(newParentId);
    newRelationEntry ??= <String>[];

    final newNotifier = _notifiers[newParentId];
    var notifierChildren = <File>[];
    if (newNotifier != null) {
      notifierChildren = newNotifier.value;
    }

    for (final folder in folders) {
      // --- STORAGE CHANGES ---
      final folderParentId = getParentIdFromChildId(folder.uid);
      // remove old folder relation to parent
      final relationEntry = _relationsBox.get(folderParentId);
      if (relationEntry != null) {
        relationEntry.remove(folder.uid);
        await _relationsBox.put(folderParentId, relationEntry);
      }
      // add folder to new relation entry
      newRelationEntry.add(folder.uid);

      // --- FRONTEND UPDATE CHANGES ---
      // remove from old notifier
      final oldNotifier = _notifiers[folderParentId];
      if (oldNotifier != null) {
        final children = oldNotifier.value..remove(folder);
        oldNotifier.value = List.from(children);
      }
      notifierChildren.add(folder);
    }

    if (newNotifier != null) {
      newNotifier.value = List.from(notifierChildren);
    }
    await _relationsBox.put(newParentId, newRelationEntry);
  }

  @override
  Future<void> moveCards(List<Card> cards, String newParentId) async {
    var newRelationEntry = _relationsBox.get(newParentId);
    newRelationEntry ??= <String>[];

    final newNotifier = _notifiers[newParentId];
    var notifierChildren = <File>[];
    if (newNotifier != null) {
      notifierChildren = newNotifier.value;
    }

    for (final card in cards) {
      // --- STORAGE CHANGES ---
      final cardParentId = getParentIdFromChildId(card.uid);
      // remove old folder relation to parent
      final relationEntry = _relationsBox.get(cardParentId);
      if (relationEntry != null) {
        relationEntry.remove(card.uid);
        await _relationsBox.put(cardParentId, relationEntry);
      }
      // add folder to new relation entry
      newRelationEntry.add(card.uid);

      // --- FRONTEND UPDATE CHANGES ---
      // remove from old notifier
      final oldNotifier = _notifiers[cardParentId];
      if (oldNotifier != null) {
        final children = oldNotifier.value..remove(card);
        oldNotifier.value = List.from(children);
      }
      notifierChildren.add(card);
    }

    if (newNotifier != null) {
      newNotifier.value = List.from(notifierChildren);
    }
    await _relationsBox.put(newParentId, newRelationEntry);
  }

  @override
  List<Subject> searchSubject(String searchRequest) {
    final foundSubjects = <Subject>[];
    final subjects = _subjectBox.values.toList();
    for (final subject in subjects) {
      // if name matches search string
      if (subject.name.toLowerCase().contains(searchRequest.toLowerCase())) {
        foundSubjects.add(subject);
      }
    }
    return foundSubjects;
  }

  @override
  List<SearchResult> searchFolder(String searchRequest, String? id) {
    final foundFolders = <SearchResult>[];
    final folderIds = id != null ? getChildrenList(id) : _folderBox.keys;
    for (final id in folderIds) {
      final folder = _folderBox.get(id);
      if (folder != null &&
          folder.name.toLowerCase().contains(searchRequest.toLowerCase())) {
        final parentObjects = <Object>[];
        var currentId = folder.uid;
        while (true) {
          try {
            final parentId = getParentIdFromChildId(currentId);
            final potentialFolder = _folderBox.get(parentId);
            if (potentialFolder != null) {
              parentObjects.add(potentialFolder);
              currentId = potentialFolder.uid;
            } else {
              final potentialSubject = _subjectBox.get(parentId);
              if (potentialSubject != null) {
                parentObjects.add(potentialSubject);
                currentId = potentialSubject.uid;
              } else {
                break;
              }
            }
          } catch (e) {
            break;
          }
        }
        foundFolders.add(
          SearchResult(
            searchedObject: folder,
            parentObjects: parentObjects,
          ),
        );
      }
    }
    return foundFolders;
  }

  @override
  List<SearchResult> searchCard(String searchRequest, String? id) {
    return [];
  }

  Future<void> _deleteFolders(List<String> ids, bool updateNotifier) async {
    for (var i = 0; i < ids.length; i++) {
      final folderId = ids[i];
      final parentId = getParentIdFromChildId(ids[i]);
      // get all ids of children
      final childrenIds = getChildrenList(folderId);
      // iterate over all children of folder
      for (final childrenId in childrenIds) {
        // dispose subscribed notifiers
        disposeNotifier(childrenId);
        // delete children in card or folder box
        if (_cardBox.get(childrenId) != null) {
          await _cardBox.delete(childrenId);
        } else if (_folderBox.get(childrenId) != null) {
          await _folderBox.delete(childrenId);
        } else {
          throw FolderNotFoundException();
        }
        // delete entries of children in relations box
        await _relationsBox.delete(childrenId);
      }
      // remove folder from folderBox and relationBox directly
      await _folderBox.delete(folderId);
      await _relationsBox.delete(folderId);
      // remove folder from parent relation entry
      final currentRelationEntry = _relationsBox.get(parentId);
      if (currentRelationEntry != null) {
        currentRelationEntry.remove(folderId);
        await _relationsBox.put(parentId, currentRelationEntry);
      }
      if (updateNotifier == true) {
        // remove folder from _notifier
        final currentNotifier = _notifiers[parentId];
        if (currentNotifier != null) {
          final children = currentNotifier.value
            ..remove(_folderBox.get(folderId));
          currentNotifier.value = children;
        }
      }
    }
  }

  @override
  void disposeNotifier(String id) {
    // dispose all children of id and id itself
    final childrenList = getChildrenList(id)..add(id);
    for (final childId in childrenList) {
      if (_notifiers[childId] != null) {
        _notifiers[childId]!.dispose();
        _notifiers.remove(childId);
      }
    }
  }

  @override
  String getParentIdFromChildId(String id) {
    final values = _relationsBox.values.toList();
    for (var i = 0; i < values.length; i++) {
      final childrenIds = values[i];
      for (final childrenId in childrenIds) {
        if (childrenId == id) {
          return _relationsBox.keyAt(i) as String;
        }
      }
    }
    throw ParentNotFoundException();
  }

  @override
  List<String> getChildrenList(String parentId) {
    final childrenIds = _recursive(parentId, []);
    return childrenIds;
  }

  // get direct children below
  @override
  List<String> getChildrenDirectlyBelow(String parentId) {
    final list = _relationsBox.get(parentId);
    return list ?? [];
  }

  // folder, subject or card from id
  @override
  Object? objectFromId(String id) {
    final potentialCard = _cardBox.get(id);
    if (potentialCard != null) {
      return Card;
    }
    final potentialFolder = _folderBox.get(id);
    if (potentialFolder != null) {
      return Folder;
    }
    final potentialSubject = _cardBox.get(id);
    if (potentialSubject != null) {
      return Subject;
    }
    return null;
  }

  List<String> _recursive(String parentId, List<String> childrenIds) {
    final newChildIds = _relationsBox.get(parentId);
    if (newChildIds != null) {
      for (final id in newChildIds) {
        childrenIds.add(id);
        _recursive(id, childrenIds);
      }
    }
    return childrenIds;
  }

  // static const List<String> _ASCIICHARS = [
  //   '!',
  //   '"',
  //   '#',
  //   '%',
  //   '&',
  //   "'",
  //   '(',
  //   ')',
  //   '*',
  //   '+',
  //   ',',
  //   '-',
  //   '.',
  //   '/',
  //   '0',
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  //   '5',
  //   '6',
  //   '7',
  //   '8',
  //   '9',
  //   ':',
  //   ';',
  //   '<',
  //   '=',
  //   '>',
  //   '?',
  //   '@',
  //   'A',
  //   'B',
  //   'C',
  //   'D',
  //   'E',
  //   'F',
  //   'G',
  //   'H',
  //   'I',
  //   'J',
  //   'K',
  //   'L',
  //   'M',
  //   'N',
  //   'O',
  //   'P',
  //   'Q',
  //   'R',
  //   'S',
  //   'T',
  //   'U',
  //   'V',
  //   'W',
  //   'X',
  //   'Y',
  //   'Z',
  //   '[',
  //   ']',
  //   '_',
  //   '`',
  //   'a',
  //   'b',
  //   'c',
  //   'd',
  //   'e',
  //   'f',
  //   'g',
  //   'h',
  //   'i',
  //   'j',
  //   'k',
  //   'l',
  //   'm',
  //   'n',
  //   'o',
  //   'p',
  //   'q',
  //   'r',
  //   's',
  //   't',
  //   'u',
  //   'v',
  //   'w',
  //   'x',
  //   'y',
  //   'z',
  //   '{',
  //   '|',
  //   '}',
  //   '~',
  //   '¡',
  //   'À',
  //   'Á',
  //   'Â',
  //   'Ã',
  //   'Ä',
  //   'Å',
  //   'Æ',
  //   'Ç',
  //   'È',
  //   'É',
  //   'Ê',
  //   'Ë',
  //   'Ì',
  //   'Í',
  //   'Î',
  //   'Ï',
  //   'Ð',
  //   'Ñ',
  //   'Ò',
  //   'Ó',
  //   'Ô',
  //   'Õ',
  //   'Ö',
  //   '×',
  //   'Ø',
  //   'Ù',
  //   'Ú',
  //   'Û',
  //   'Ü',
  //   'Ý',
  //   'Þ',
  //   'ß',
  //   'à',
  //   'á',
  //   'â',
  //   'ã',
  //   'ä',
  //   'å',
  //   'æ',
  //   'ç',
  //   'è',
  //   'é',
  //   'ê',
  //   'ë',
  //   'ì',
  //   'í',
  //   'î',
  //   'ï',
  //   'ð',
  //   'ñ',
  //   'ò',
  //   'ó',
  //   'ô',
  //   'õ',
  //   'ö',
  //   '÷',
  //   'ø',
  //   'ù',
  //   'ú',
  //   'û',
  //   'ü',
  //   'ý',
  //   'þ',
  //   'ÿ'
  // ];

  // /// stream for passing all stored subjects to frontend
  // final _subjectStreamController =
  //     BehaviorSubject<List<Subject>>.seeded(const []);

  // /// all previous paths that the system knows,
  // /// entries never get removed during runtime
  // List<String> _indexedPaths = [];

  // /// Map of <parentId, Stream>
  // final Map<String, BehaviorSubject<List<Object>>> _subscribedStreams = {};
  // Map<dynamic, dynamic> _storeIds = {};

  // void _init() {
  //   // load all saved indexedPaths
  //   try {
  //     _indexedPaths = _hiveBox.get('indexed_paths') as List<String>;
  //   } catch (e) {
  //     log('\x1B[32mno paths saved\x1B[32m');
  //   }
  //   // load all saved subjects
  //   try {
  //     final subjectJson = _hiveBox.get('/subjects') as List<String>;
  //     _subjectStreamController.add(_subjectsFromJson(subjectJson));
  //   } catch (e) {
  //     log('\x1B[32mno subjects saved\x1B[32m');
  //   }
  //   // load all storedIds
  //   try {
  //     _storeIds = _hiveBox.get('/store_ids') as Map<dynamic, dynamic>;
  //   } catch (e) {
  //     log('\x1B[32mno storeIds saved\x1B[32m');
  //   }
  // }

  // List<String> _cardsToJson(List<Card> cards) {
  //   final jsonCards = <String>[];
  //   for (final element in cards) {
  //     jsonCards.add(element.toJson());
  //   }
  //   return jsonCards;
  // }

  // List<String> _foldersToJson(List<Folder> folders) {
  //   final jsonFolders = <String>[];
  //   for (final element in folders) {
  //     jsonFolders.add(element.toJson());
  //   }
  //   return jsonFolders;
  // }

  // List<String> _subjectsToJson(List<Subject> cards) {
  //   final jsonSubjects = <String>[];
  //   for (final element in cards) {
  //     jsonSubjects.add(element.toJson());
  //   }
  //   return jsonSubjects;
  // }

  // List<Card> _cardsFromJson(List<String> json) {
  //   final cards = <Card>[];
  //   for (final element in json) {
  //     cards.add(Card.fromJson(element));
  //   }
  //   return cards;
  // }

  // List<Folder> _foldersFromJson(List<String> json) {
  //   final folders = <Folder>[];
  //   for (final element in json) {
  //     folders.add(Folder.fromJson(element));
  //   }
  //   return folders;
  // }

  // List<Subject> _subjectsFromJson(List<String> json) {
  //   final subjects = List<Subject>.empty(growable: true);
  //   for (final element in json) {
  //     subjects.add(Subject.fromJson(element));
  //   }
  //   return subjects;
  // }

  // @override
  // Future<void> deleteCard(String id, String parentId) async {
  //   await _deleteCards([id], [parentId]);
  // }

  // @override
  // Future<void> deleteCards(List<String> id, List<String> parentId) async {
  //   await _deleteCards(id, parentId);
  // }

  // @override
  // Future<void> deleteSubject(String id) {
  //   final subjects = _subjectStreamController.value;
  //   final subjectIndex = subjects.indexWhere((element) => element.id == id);
  //   if (subjectIndex == -1) {
  //     throw SubjectNotFoundException();
  //   } else {
  //     subjects.removeAt(subjectIndex);
  //     _deleteChildPaths('/subjects/$id');
  //     _subjectStreamController.add(subjects);
  //     return _hiveBox.put('/subjects', subjects);
  //   }
  // }

  // @override
  // Future<void> deleteFolder(String id, String parentId) async {
  //   await _deleteFolder(id, parentId);
  //   return;
  // }

  // @override
  // Stream<List<Subject>> getSubjects() =>
  //     _subjectStreamController.asBroadcastStream();

  // @override
  // Stream<List<Object>> getChildrenById(String id) {
  //   final newStream = BehaviorSubject<List<Object>>.seeded(const []);
  //   final path = _getPath(id);
  //   if (path == null) {
  //     throw StreamNotFoundException();
  //   }
  //   final childrenStrings =
  //       _hiveBox.get(_makePathStorable(path)) as List<String>?;
  //   final children = <Object>[];
  //   if (childrenStrings != null) {
  //     for (final element in childrenStrings) {
  //       try {
  //         children.add(Card.fromJson(element));
  //       } catch (e) {
  //         children.add(Folder.fromJson(element));
  //       }
  //     }
  //   }

  //   newStream.add(children);
  //   _subscribedStreams[path] = newStream;
  //   return newStream;
  // }

  // @override
  // Future<void> saveSubject(Subject subject) {
  //   var subjects = _subjectStreamController.value;
  //   if (subjects.isEmpty) subjects = [];
  //   final subjectIndex =
  //       subjects.indexWhere((element) => element.id == subject.id);
  //   if (subjectIndex >= 0) {
  //     subjects[subjectIndex] = subject;
  //   } else {
  //     subjects.add(subject);
  //   }
  //   _subjectStreamController.add(subjects);
  //   _indexedPaths.add('/subjects/${subject.id}');
  //   _saveIndexedPaths();
  //   return _hiveBox.put('/subjects', _subjectsToJson(subjects));
  // }

  // @override
  // Future<void> saveFolder(Folder folder) {
  //   final parentId = folder.parentId;

  //   final path = _getPath(parentId);

  //   if (path == null) {
  //     throw ParentNotFoundException();
  //   }
  //   if (!_indexedPaths.contains('$path/${folder.id}')) {
  //     _indexedPaths.add('$path/${folder.id}');
  //     _saveIndexedPaths();
  //   }
  //   var folders = _hiveBox.get(_makePathStorable(path)) as List<String>?;
  //   var found = false;
  //   var indexToChange = -1;

  //   if (folders != null) {
  //     for (final element in folders) {
  //       if (element.substring(7).startsWith(folder.id)) {
  //         // element = folder.toJson();
  //         indexToChange = folders.indexOf(element);
  //         found = true;
  //         break;
  //       }
  //     }
  //   } else {
  //     folders = [];
  //   }

  //   if (!found) {
  //     folders.add(folder.toJson());
  //   }else{
  //     folders[indexToChange] = folder.toJson();
  //   }
  //   if (_subscribedStreams.containsKey(path)) {
  //     _subscribedStreams[path]!.add([folder]);
  //   }
  //   return _hiveBox.put(_makePathStorable(path), folders);
  // }

  // @override
  // Future<void> saveCard(Card card) {
  //   final parentId = card.parentId;

  //   final path = _getPath(parentId);

  //   if (path == null) {
  //     throw ParentNotFoundException();
  //   }

  //   var cards = _hiveBox.get(_makePathStorable(path)) as List<String>?;
  //   var found = false;
  //   var indexToChange = -1;
  //   if (cards != null) {
  //     for (final element in cards) {
  //       // contains word
  //       if (element.substring(7).startsWith(card.id)) {
  //         indexToChange = cards.indexOf(element);
  //         found = true;
  //         break;
  //       }
  //     }
  //   } else {
  //     cards = [];
  //   }
  //   if (!found) {
  //     cards.add(card.toJson());
  //   } else {
  //     cards[indexToChange] = card.toJson();
  //   }

  //   if (_subscribedStreams.containsKey(path)) {
  //     _subscribedStreams[path]!.add([card]);
  //   }
  //   return _hiveBox.put(_makePathStorable(path), cards);
  // }

  // @override
  // Future<void> moveFolder(Folder folder, String newParentId) async {
  //   await _deleteFolder(folder.id, folder.parentId, deleteChildPaths: false);
  //   await _moveChildPaths(folder.id, newParentId);
  //   final newFolder = folder.copyWith(parentId: newParentId);
  //   await saveFolder(newFolder);
  // }

  // @override
  // Future<void> moveCards(List<Card> cards, String newParentId) async {
  //   final newPath = _getPath(newParentId);

  //   if (newPath == null) {
  //     throw ParentNotFoundException();
  //   }
  //   final updateEvents = <String, List<Object>>{};

  //   final cardIds = <String>[];
  //   final cardParentIds = <String>[];

  //   for (final card in cards) {
  //     cardIds.add(card.id);
  //     cardParentIds.add(card.parentId);
  //     final newCard = card.copyWith(parentId: newParentId);
  //     final currentPath = _getPath(card.parentId);
  //     if (currentPath == null) {
  //       throw ParentNotFoundException();
  //     }

  //     var loadedNewCards =
  //         await _hiveBox.get(_makePathStorable(newPath)) as List<String>?;
  //     var found = false;
  //     var indexToChange = 0;
  //     if (loadedNewCards != null) {
  //       for (final element in loadedNewCards) {
  //         // contains word
  //         if (element.substring(7).startsWith(newCard.id)) {
  //           indexToChange = loadedNewCards.indexOf(element);
  //           found = true;
  //           break;
  //         }
  //       }
  //     } else {
  //       loadedNewCards = [];
  //     }
  //     if (!found) {
  //       loadedNewCards.add(newCard.toJson());
  //     } else {
  //       loadedNewCards[indexToChange] = newCard.toJson();
  //     }

  //     if (updateEvents[newPath] == null) {
  //       updateEvents[newPath] = [newCard];
  //     } else {
  //       updateEvents[newPath]!.add(newCard);
  //     }

  //     await _hiveBox.put(_makePathStorable(newPath), loadedNewCards);
  //   }
  //   updateEvents
  //     ..addAll(
  //       await _deleteCards(cardIds, cardParentIds, notifyListeners: false),
  //     )
  //     ..forEach((key, value) {
  //       if (_subscribedStreams.containsKey(key)) {
  //         _subscribedStreams[key]!.add(value);
  //       }
  //     });
  // }

  // @override
  // Future<void> closeStreamById(String id, {bool deleteChildren = false}) async {
  //   final path = _getPath(id);
  //   if (deleteChildren) {
  //     final childPaths = _getChildrenPaths(id);
  //     if (childPaths != null) {
  //       for (final element in childPaths) {
  //         if (_subscribedStreams[element] != null) {
  //           await _subscribedStreams[element]!.close();
  //           _subscribedStreams.remove(element);
  //         }
  //       }
  //     }
  //   }
  //   if (_subscribedStreams[path] != null) {
  //     await _subscribedStreams[path]!.close();
  //     _subscribedStreams.remove(path);
  //   }
  // }

  // @override
  // List<Card> learnAllCards() {
  //   final cardsToLearn = <Card>[];
  //   final now = DateTime.now();
  //   for (final element in _indexedPaths) {
  //     final loadedCardStrings =
  //         _hiveBox.get(_makePathStorable(element)) as List<String>?;
  //     if (loadedCardStrings == null) continue;
  //     for (final loadedCardString in loadedCardStrings) {
  //       if (loadedCardString.substring(46).startsWith('front')) {
  //         final card = Card.fromJson(loadedCardString);
  //         try {
  //           if (DateTime.parse(card.dateToReview).compareTo(now) < 0) {
  //             cardsToLearn.add(card);
  //           }
  //         } catch (e) {
  //           cardsToLearn.add(card);
  //           final newCard =
  //               card.copyWith(dateToReview: DateTime.now().toIso8601String());
  //           saveCard(newCard);
  //         }
  //       }
  //     }
  //   }
  //   return cardsToLearn;
  // }

  // @override
  // List<SearchResult> searchCard(String searchRequest, String? id) {
  //   final searchResults = <SearchResult>[];
  //   for (final indexedPath in _indexedPaths) {
  //     if (id != null && !indexedPath.contains(id)) continue;
  //     final loadedCardStrings =
  //         _hiveBox.get(_makePathStorable(indexedPath)) as List<String>?;
  //     if (loadedCardStrings == null) continue;
  //     for (final loadedCardString in loadedCardStrings) {
  //       if (loadedCardString.toLowerCase().contains(searchRequest)) {
  //         try {
  //           final card = Card.fromJson(loadedCardString);
  //           if (card.front
  //                   .toLowerCase()
  //                   .contains(searchRequest.toLowerCase()) ||
  //               card.back.toLowerCase().contains(searchRequest.toLowerCase())) {
  //             searchResults.add(SearchResult(
  //                 searchedObject: card,
  //                 parentObjects: _getParentNamesFromPath(indexedPath)));
  //           }
  //         } catch (e) {
  //           continue;
  //         }
  //       }
  //     }
  //   }
  //   return searchResults;
  // }

  // @override
  // List<Subject> searchSubject(String searchRequest) {
  //   final foundSubjects = <Subject>[];

  //   final loadedCardStrings = _hiveBox.get("/subjects") as List<String>?;
  //   if (loadedCardStrings == null) return List.empty();
  //   for (final loadedCardString in loadedCardStrings) {
  //     if (!loadedCardString.substring(46).startsWith('front') &&
  //         loadedCardString
  //             .toLowerCase()
  //             .contains(searchRequest.toLowerCase())) {
  //       final subject = Subject.fromJson(loadedCardString);
  //       if (subject.name.toLowerCase().contains(searchRequest.toLowerCase())) {
  //         foundSubjects.add(subject);
  //       }
  //     }
  //   }

  //   return foundSubjects;
  // }

  // @override
  // List<SearchResult> searchFolder(String searchRequest, String? id) {
  //   final searchResults = <SearchResult>[];
  //   for (final indexedPath in _indexedPaths) {
  //     if (id != null && !indexedPath.contains(id)) continue;

  //     final loadedCardStrings =
  //         _hiveBox.get(_makePathStorable(indexedPath)) as List<String>?;
  //     if (loadedCardStrings == null) continue;
  //     for (final loadedCardString in loadedCardStrings) {
  //       if (!loadedCardString.substring(46).startsWith('front') &&
  //           loadedCardString.toLowerCase().contains(searchRequest)) {
  //         try {
  //           final folder = Folder.fromJson(loadedCardString);
  //           if (folder.name
  //               .toLowerCase()
  //               .contains(searchRequest.toLowerCase())) {
  //             searchResults.add(SearchResult(
  //                 searchedObject: folder,
  //                 parentObjects: _getParentNamesFromPath(indexedPath)));
  //           }
  //         } catch (e) {
  //           continue;
  //         }
  //       }
  //     }
  //   }
  //   return searchResults;
  // }

  // List<Object> _getParentNamesFromPath(String path) {
  //   final parentNames = <Object>[];
  //   var currentPath = path;
  //   var idToMatch = '';

  //   while (true) {
  //     final regex = RegExp('^(.*)/');
  //     final match = regex.firstMatch(currentPath);
  //     if (match != null && match.group(1) != '') {
  //       final newPath = match.group(1)!;
  //       idToMatch = currentPath.substring(newPath.length + 1);
  //       currentPath = newPath;

  //       if (currentPath == '/subjects') {
  //         final subjects = _subjectStreamController.value;
  //         for (final element in subjects) {
  //           if (element.id == idToMatch) {
  //             parentNames.add(element);
  //             return parentNames.reversed.toList();
  //           }
  //         }
  //       }

  //       final elements =
  //           _hiveBox.get(_makePathStorable(currentPath)) as List<String>?;
  //       innerLoop:
  //       for (final element in elements!) {
  //         try {
  //           final folder = Folder.fromJson(element);
  //           if (folder.id == idToMatch) {
  //             parentNames.add(folder);
  //             break innerLoop;
  //           }
  //         } catch (e) {
  //           // element is no folder
  //         }
  //       }
  //     } else {
  //       return parentNames.reversed.toList();
  //     }
  //   }
  // }

  // String? _getPath(String parentId) {
  //   for (final element in _indexedPaths) {
  //     if (element.endsWith(parentId)) {
  //       return element;
  //     }
  //   }
  //   return null;
  // }

  // String _makePathStorable(String path) {
  //   final singleIds = path.split('/');
  //   singleIds
  //     ..removeAt(0)
  //     ..removeAt(0);
  //   var newPath = '/subjects';
  //   for (final id in singleIds) {
  //     if (_storeIds.containsKey(id)) {
  //       newPath += '/${_storeIds[id]!}';
  //     } else {
  //       var newKey = _ASCIICHARS[0];
  //       if (_storeIds.isNotEmpty) {
  //         newKey =
  //             (_addOneToString(_storeIds.values.last as String)).toString();
  //       }
  //       _storeIds[id] = newKey;
  //       newPath += '/${_storeIds[id]!}';
  //       _hiveBox.put('/store_ids', _storeIds);
  //     }
  //   }
  //   return newPath;
  // }

  // List<String>? _getChildrenPaths(String parentId) {
  //   final paths = <String>[];
  //   for (final element in _indexedPaths) {
  //     if (element.contains(parentId)) {
  //       paths.add(element);
  //     }
  //   }
  //   return paths;
  // }

  // Future<void> _deleteChildPaths(String id) {
  //   final newIndexedPaths = <String>[];
  //   for (final element in _indexedPaths) {
  //     if (element.contains(id)) {
  //       _hiveBox.delete(element);
  //     } else {
  //       newIndexedPaths.add(element);
  //     }
  //   }
  //   _indexedPaths = newIndexedPaths;
  //   return _saveIndexedPaths();
  // }

  // Future<void> _moveChildPaths(String oldId, String newId) async {
  //   final newPrefix = _getPath(newId);
  //   if (newPrefix == null) {
  //     throw ParentNotFoundException();
  //   }
  //   final newIndexPaths = <String>[];
  //   for (final element in _indexedPaths) {
  //     if (element.contains(oldId)) {
  //       final newPath =
  //           '$newPrefix/${element.substring(element.indexOf(oldId))}';
  //       newIndexPaths.add(newPath);
  //       final previousStoredObjects =
  //           _hiveBox.get(_makePathStorable(element)) as List<String>?;
  //       if (previousStoredObjects != null) {
  //         await _hiveBox.delete(element);
  //         await _hiveBox.put(_makePathStorable(newPath), previousStoredObjects);
  //       }
  //     } else {
  //       newIndexPaths.add(element);
  //     }
  //   }
  //   _indexedPaths = newIndexPaths;
  //   return _saveIndexedPaths();
  // }

  // Future<void> _saveIndexedPaths() async {
  //   final newIndexPaths = _indexedPaths.toSet().toList();
  //   await _hiveBox.put('indexed_paths', newIndexPaths);
  // }

  // String _addOneToString(String previous) {
  //   if (previous.isEmpty) return '';
  //   final currentIndex = _ASCIICHARS.indexOf(previous[previous.length - 1]);
  //   if (currentIndex == _ASCIICHARS.length - 1) {
  //     if ((previous.substring(0, previous.length - 1)).isEmpty) {
  //       return _ASCIICHARS[1] + _ASCIICHARS[0];
  //     }
  //     return _addOneToString(previous.substring(0, previous.length - 1)) +
  //         _ASCIICHARS[0];
  //   } else {
  //     return previous.substring(0, previous.length - 1) +
  //         _ASCIICHARS[currentIndex + 1];
  //   }
  // }

  // Future<Map<String, List<Removed>>> _deleteCards(
  //   List<String> ids,
  //   List<String> parentIds, {
  //   bool notifyListeners = true,
  // }) async {
  //   if (ids.length != parentIds.length) throw WrongInput();

  //   final pathsToRemove = <String>[];
  //   final parentIdsToDeletedIds = <String, List<Removed>>{};

  //   for (var i = 0; i < ids.length; i++) {
  //     final currentPath = _getPath(parentIds[i]);
  //     if (currentPath == null) throw ParentNotFoundException();
  //     if (!pathsToRemove.contains(currentPath)) {
  //       pathsToRemove.add(currentPath);
  //     }
  //     parentIdsToDeletedIds[currentPath] == null
  //         ? parentIdsToDeletedIds[currentPath] = [Removed(id: ids[i])]
  //         : parentIdsToDeletedIds[currentPath]!.add(Removed(id: ids[i]));

  //     final loadedCards =
  //         await _hiveBox.get(_makePathStorable(currentPath)) as List<String>?;
  //     var found = false;
  //     if (loadedCards != null) {
  //       for (final card in loadedCards) {
  //         if (card.substring(7).startsWith(ids[i])) {
  //           loadedCards.remove(card);
  //           found = true;
  //           break;
  //         }
  //       }
  //     }
  //     if (!found) throw ParentNotFoundException();
  //     await _hiveBox.put(_makePathStorable(currentPath), loadedCards);
  //   }

  //   if (notifyListeners) {
  //     for (final path in pathsToRemove) {
  //       if (_subscribedStreams.containsKey(path)) {
  //         _subscribedStreams[path]!.add(parentIdsToDeletedIds[path]!);
  //       }
  //     }
  //   }
  //   return parentIdsToDeletedIds;
  // }

  // Future<void> _deleteFolder(
  //   String id,
  //   String parentId, {
  //   bool deleteChildPaths = true,
  // }) async {
  //   final path = _getPath(parentId);
  //   if (path == null) {
  //     throw ParentNotFoundException();
  //   }
  //   final folders =
  //       await _hiveBox.get(_makePathStorable(path)) as List<String>?;
  //   var found = false;
  //   if (folders != null) {
  //     for (final element in folders) {
  //       if (element.substring(7).startsWith(id)) {
  //         folders.remove(element);
  //         found = true;
  //         break;
  //       }
  //     }
  //   }
  //   if (found == false) {
  //     throw ParentNotFoundException();
  //   }
  //   if (_subscribedStreams.containsKey(path)) {
  //     _subscribedStreams[path]!.add([Removed(id: id)]);
  //   }
  //   if (deleteChildPaths == true) {
  //     await _deleteChildPaths(id);
  //   }
  //   return _hiveBox.put(_makePathStorable(path), folders);
  // }
}
