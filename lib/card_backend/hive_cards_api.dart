// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:learning_app/card_backend/cards_api/cards_api.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/file.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/search_result.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_app/editor/helper/data_class_helper.dart';
import 'package:learning_app/editor/models/editor_data_classes/editor_tile_dc.dart';
import 'package:learning_app/editor/models/editor_tile.dart';

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
    this._cardContentBox,
  ) {
    _init();
  }

  final Box<Subject> _subjectBox;
  final Box<Folder> _folderBox;
  final Box<Card> _cardBox;
  final Box<List<String>> _relationsBox;
  final Box<List<dynamic>> _cardContentBox;

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
  List<Card> getAllCardsToLearnForToday() {
    final now = DateUtils.dateOnly(DateTime.now());
    var a = _cardBox.values.where((element) {
      final dateToReview = DateUtils.dateOnly(element.dateToReview);
      return (dateToReview.isBefore(now) || dateToReview.isAtSameMomentAs(now));
    }).toList();
    return a;
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
    for (final childrenId in childrenIds) {
      final card = _cardBox.get(childrenId);
      if (card == null) {
        final folder = _folderBox.get(childrenId);
        if (folder != null) {
          children.add(folder);
        } else {
          throw FolderNotFoundException();
        }
      } else {
        children.add(card);
      }
    }
    valueNotifier.value = children;
    return valueNotifier;
  }

  @override
  Future<List<EditorTile>> getCardContent(String cardId) async {
    final editorTilesDC = _cardContentBox.get(cardId);
    if (editorTilesDC != null) {
      return DataClassHelper.convertFromDataClass(editorTilesDC);
    } else {
      return <EditorTile>[];
    }
  }

  @override
  Folder? getFolderById(String folderUID) {
    return _folderBox.get(folderUID);
  }

  @override
  Card? getCardById(String cardUID) {
    return _cardBox.get(cardUID);
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
      if (!relations.contains(folder.uid)) {
        relations.add(folder.uid);
        await _relationsBox.put(parentId, relations);
      }
    }
    // update notifiers
    final currentNotifier = _notifiers[parentId];
    var alreadyUpdated = false;

    if (currentNotifier != null) {
      final children = currentNotifier.value;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        if (child.uid == folder.uid) {
          children[i] = folder;
          currentNotifier.value = List.from(children);
          alreadyUpdated = true;
          break;
        }
      }
      if (!alreadyUpdated) {
        children.add(folder);
      }
      currentNotifier.value = List.from(children);
    }
  }

  @override
  Future<void> saveCard(
    Card card,
    List<EditorTile>? editorTiles,
    String? parentId_,
  ) async {
    final parentId = parentId_ ?? getParentIdFromChildId(card.uid);
    // add card to _cardBox
    await _cardBox.put(card.uid, card);

    // add card to relations
    final relations = _relationsBox.get(parentId);
    if (relations == null) {
      await _relationsBox.put(parentId, [card.uid]);
    } else {
      if (!relations.contains(card.uid)) {
        relations.add(card.uid);
        await _relationsBox.put(parentId, relations);
      }
    }

    // update notifiers
    var alreadyUpdated = false;
    final currentNotifier = _notifiers[parentId];
    if (currentNotifier != null) {
      final children = currentNotifier.value;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        if (child.uid == card.uid) {
          children[i] = card;
          alreadyUpdated = true;
          break;
        }
      }
      if (!alreadyUpdated) {
        children.add(card);
      }
      currentNotifier.value = List.from(children);
    }

    // save content of card
    if (editorTiles != null && editorTiles.isNotEmpty) {
      final editorTilesDC = DataClassHelper.convertToDataClass(editorTiles);
      await _cardContentBox.put(card.uid, editorTilesDC);
    }
  }

  @override
  List<String> getTextFromCard(String cardId, bool onlyFront) {
    final editorTilesDC = _cardContentBox.get(cardId);
    if (editorTilesDC == null || editorTilesDC.isEmpty) {
      return [];
    }
    return DataClassHelper.getFrontAndBackText(
      editorTilesDC as List<EditorTileDC>,
      onlyFront,
    );
  }

  @override
  Future<void> deleteSubject(String id) async {
    await _subjectBox.delete(id);
    final children = getChildrenList(id);
    disposeNotifier(id);
    await _deleteFiles(children, false);
  }

  @override
  Future<void> moveFiles(List<String> fileIds, String newParentId) async {
    var newRelationEntry = _relationsBox.get(newParentId);
    newRelationEntry ??= <String>[];

    final newNotifier = _notifiers[newParentId];
    var notifierChildren = <File>[];
    if (newNotifier != null) {
      notifierChildren = newNotifier.value;
    }
    final files = <String, List<File>>{};
    for (final fileId in fileIds) {
      final file = objectFromId(fileId);
      if (file != null && file is File) {
        final fileParentId = getParentIdFromChildId(fileId);

        // remove old folder relation to parent
        final relationEntry = _relationsBox.get(fileParentId);
        if (relationEntry != null) {
          relationEntry.remove(fileId);
          await _relationsBox.put(fileParentId, relationEntry);
        }
        // add folder to new relation entry
        newRelationEntry.add(fileId);

        // add folder to files map to later update notifiers
        if (files[fileParentId] != null) {
          files[fileParentId]!.add(file);
        } else {
          files[fileParentId] = [file];
        }

        // add file to new notifier
        notifierChildren.add(file);
      }
    }

    files.forEach((key, value) {
      final oldNotifier = _notifiers[key];
      if (oldNotifier != null) {
        final children = oldNotifier.value;

        for (final element in value) {
          children.remove(element);
        }
        oldNotifier.value = List.from(children);
      }
    });

    // for (final fileId in fileIds) {
    //   final file = objectFromId(fileId);
    //   if (file != null && file is File) {
    //     // --- STORAGE CHANGES ---
    //     final fileParentId = getParentIdFromChildId(fileId);
    //     if (fileParentId != newParentId) {
    //       // remove old folder relation to parent
    //       final relationEntry = _relationsBox.get(fileParentId);
    //       if (relationEntry != null) {
    //         relationEntry.remove(fileId);
    //         await _relationsBox.put(fileParentId, relationEntry);
    //       }
    //       // add folder to new relation entry
    //       newRelationEntry.add(fileId);

    //       // --- FRONTEND UPDATE CHANGES ---
    //       // remove from old notifier
    //       final oldNotifier = _notifiers[fileParentId];
    //       if (oldNotifier != null) {
    //         final children = oldNotifier.value..remove(file);
    //         oldNotifier.value = List.from(children);
    //       }
    //       notifierChildren.add(file);
    //     }
    //   }
    // }

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
      if (subject.name.toLowerCase().trim().contains(searchRequest)) {
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
          folder.name.toLowerCase().trim().contains(searchRequest)) {
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
                break;
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
    final foundCards = <SearchResult>[];
    final cardIds = id != null ? getChildrenList(id) : _cardBox.keys;
    for (final id in cardIds) {
      var cardContent = _cardContentBox.get(id);
      final card = _cardBox.get(id);
      try {
        if (cardContent != null && card != null) {
          cardContent = cardContent.cast<EditorTileDC>().toList();
        } else if (card == null) {
          continue;
        }
      } catch (e) {
        continue;
      }
      if (cardContent is List<EditorTileDC>) {
        final textList = DataClassHelper.getFrontAndBackText(
          cardContent,
          false,
        );
        var text = '';
        for (final element in textList) {
          text += '$element\n';
        }
        if (card.name.toLowerCase().trim().contains(searchRequest) ||
            text.toLowerCase().trim().contains(searchRequest)) {
          final card = _cardBox.get(id);
          if (card == null) {
            continue;
          }
          final parentObjects = <Object>[];
          var currentId = card.uid;
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
          foundCards.add(
            SearchResult(
              searchedObject: card,
              parentObjects: parentObjects,
            ),
          );
        }
      }
    }
    return foundCards;
  }

  @override
  Future<void> deleteFiles(List<String> ids) async {
    var idsToDelete = List<String>.of(ids);
    // add children of ids
    for (final id in ids) {
      idsToDelete.addAll(getChildrenList(id));
    }
    // remove duplicates
    idsToDelete = idsToDelete.toSet().toList();
    await _deleteFiles(ids, true);
  }

  @override
  Future<void> _deleteFiles(List<String> ids, bool updateNotifier) async {
    for (var i = 0; i < ids.length; i++) {
      final fileId = ids[i];
      final file = _folderBox.get(fileId) ?? _cardBox.get(fileId);
      if (file == null) {
        throw CardNotFoundException();
      }
      try {
        final parentId = getParentIdFromChildId(ids[i]);
        // remove folder from parent relation entry
        final currentRelationEntry = _relationsBox.get(parentId);
        if (currentRelationEntry != null) {
          currentRelationEntry.remove(fileId);
          await _relationsBox.put(parentId, currentRelationEntry);
        }

        if (updateNotifier) {
          // remove folder from _notifier
          final currentNotifier = _notifiers[parentId];
          if (currentNotifier != null) {
            final children = currentNotifier.value..remove(file);
            currentNotifier.value = List.of(children);
          }
        }
      } catch (e) {}

      // get all ids of children

      if (file is Folder) {
        _deleteFolder(file.uid);
      }

      // remove file from folderBox or cardBox and relationBox directly
      // box.delete, when object not in box nothing happens
      await _folderBox.delete(fileId);
      await _cardBox.delete(fileId);
      await _cardContentBox.delete(fileId);
      await _relationsBox.delete(fileId);

      disposeNotifier(fileId);
    }
  }

  _deleteFolder(String parentFolderUID) {
    var files =
        getChildrenById(parentFolderUID).value.map((e) => e.uid).toList();

    // iterate over all children of folder
    for (final file in files) {
      // dispose subscribed notifiers
      disposeNotifier(file);
      // delete children in card or folder box
      if (_cardBox.get(file) != null) {
        _cardBox.delete(file);
        _cardContentBox.delete(file);
      } else if (_folderBox.get(file) != null) {
        _deleteFolder(file); //!rekursion
      } else {
        throw FolderNotFoundException();
      }
      // delete entries of children in relations box
      _relationsBox.delete(file);
    }
  }

  @override
  void disposeNotifier(String id) {
    // dispose all children of id and id itself
    final childrenList = getChildrenList(id)..add(id);
    for (final childId in childrenList) {
      if (_notifiers.containsKey(childId)) {
        _notifiers[childId]!.dispose();
        _notifiers.remove(childId);
      }
    }
  }

  @override
  String getParentIdFromChildId(String id) {
    final values = _relationsBox.values.toList();
    for (var i = 0; i < values.length; i++) {
      if (values[i].contains(id)) {
        return _relationsBox.keys.elementAt(i).toString();
      }
    }
    throw ParentNotFoundException();
  }

  @override
  List<String> getParentIdsFromChildId(String id) {
    final parentIds = <String>[];
    var childId = id;
    while (true) {
      parentIds.add(childId);
      try {
        childId = getParentIdFromChildId(childId);
      } catch (e) {
        return parentIds;
      }

      if (objectFromId(childId) is Subject) {
        parentIds.add(childId);
        return parentIds;
      }
    }
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
      return potentialCard;
    }
    final potentialFolder = _folderBox.get(id);
    if (potentialFolder != null) {
      return potentialFolder;
    }
    final potentialSubject = _subjectBox.get(id);
    if (potentialSubject != null) {
      return potentialSubject;
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
}
