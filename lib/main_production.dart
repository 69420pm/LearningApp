// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:hive/hive.dart';
import 'package:hive_cards_api/hive_cards_api.dart';
import 'package:learning_app/app/app.dart';
import 'package:learning_app/bootstrap.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:ui_components/ui_components.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

Future<void> main() async {
   /// Init hive
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
   Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(SubjectAdapter())
    ..registerAdapter(CardAdapter())
    ..registerAdapter(FolderAdapter())
    ..registerAdapter(ClassTestAdapter())
    ..registerAdapter(AudioTileDCAdapter())
    ..registerAdapter(CalloutTileDCAdapter())
    ..registerAdapter(CharTileDCAdapter())
    ..registerAdapter(DividerTileDCAdapter())
    ..registerAdapter(HeaderTileDCAdapter())
    ..registerAdapter(ImageTileDCAdapter())
    ..registerAdapter(LatexTileDCAdapter())
    ..registerAdapter(ListEditorTileDCAdapter())
    ..registerAdapter(QuoteTileDCAdapter())
    ..registerAdapter(TextTileDCAdapter());
  final cardsApi = HiveCardsApi(
      await Hive.openBox<Subject>('subjects'),
      await Hive.openBox<Folder>('folders'),
      await Hive.openBox<Card>('cards'),
      await Hive.openBox<List<String>>('relations'),
      await Hive.openBox<List<EditorTileDC>>('card_content'),);

  final cardsRepository = CardsRepository(cardsApi: cardsApi);

  final uiApi = HiveUIApi(await Hive.openBox('hive_ui'));
  final uiRepository = UIRepository(uiApi: uiApi);
  await bootstrap(() => App(
        cardsRepository: cardsRepository,
        uiRepository: uiRepository,
      ));
}
