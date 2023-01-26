// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_cards_api/hive_cards_api.dart';
import 'package:learning_app/app/app.dart';
import 'package:learning_app/bootstrap.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  /// Init hive
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  final cardsApi = HiveCardsApi(await Hive.openBox('hive_cards'));
  final cardsRepository = CardsRepository(cardsApi: cardsApi);

  await bootstrap(() => App(cardsRepository: cardsRepository));
}
