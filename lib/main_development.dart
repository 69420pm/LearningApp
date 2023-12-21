// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart' hide Card;
import 'package:hive/hive.dart';
import 'package:learning_app/app/app.dart';
import 'package:learning_app/bootstrap.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/card_backend/hive_cards_api.dart';
import 'package:learning_app/editor/models/editor_data_classes/front_back_seperator_tile_dc.dart';
import 'package:learning_app/ui_components/backend/hive_ui_api.dart';
import 'package:learning_app/ui_components/backend/ui_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:learning_app/editor/models/editor_data_classes/audio_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/callout_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/char_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/divider_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/header_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/image_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/latex_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/link_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/list_editor_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/quote_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/text_tile_dc.dart';
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
    ..registerAdapter(TextTileDCAdapter())
    ..registerAdapter(LinkTileDCAdapter())
    ..registerAdapter(FrontBackSeparatorTileDCAdapter());

  final cardsApi = HiveCardsApi(
      await Hive.openBox<Subject>('subjects'),
      await Hive.openBox<Folder>('folders'),
      await Hive.openBox<Card>('cards'),
      await Hive.openBox<List<String>>('relations'),
      await Hive.openBox<List<dynamic>>('card_content'),);
  final cardsRepository = CardsRepository(cardsApi: cardsApi);

  final uiApi = HiveUIApi(await Hive.openBox('hive_ui'));
  final uiRepository = UIRepository(uiApi: uiApi);
  await bootstrap(
    () => App(
      cardsRepository: cardsRepository,
      uiRepository: uiRepository,
    ),
  );
}
