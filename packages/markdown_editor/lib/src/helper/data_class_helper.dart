import 'dart:ui';

import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/audio_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/callout_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/char_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/audio_tile.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:ui_components/ui_components.dart';

class DataClassHelper {
  List<EditorTileDC> convertToDataClass(List<EditorTile> editorTiles) {
    List<EditorTileDC> dataClassTiles = [];
    for (var editorTile in editorTiles) {
      if (editorTile is AudioTile) {
        dataClassTiles
            .add(AudioTileDC(uid: Uid().uid(), filePath: editorTile.filePath));
      } else if (editorTiles is CalloutTile) {
        final calloutTile = editorTile as CalloutTile;
        // dataClassTiles.add(CalloutTileDC(uid: Uid().uid(), charTiles: calloutTile.textFieldController.charTiles, tileColor: colorToInt(calloutTile.tileColor), iconString: calloutTile.iconString))
      }
    }
    return dataClassTiles;
  }

  // make color storable
  int colorToInt(Color color) {
    switch (color) {
      case UIColors.textLight:
        return 0;
      case UIColors.red:
        return 1;
      case UIColors.yellow:
        return 2;
      case UIColors.green:
        return 3;
      case UIColors.blue:
        return 4;
      case UIColors.purple:
        return 5;
      case UIColors.smallText:
        return 6;
      default:
        return 0;
    }
  }

  // convert stored color back to color
  Color intToColor(int i) {
    switch (i) {
      case 0:
        return UIColors.textLight;
      case 1:
        return UIColors.red;
      case 2:
        return UIColors.yellow;
      case 3:
        return UIColors.green;
      case 4:
        return UIColors.blue;
      case 5:
        return UIColors.purple;
      case 6:
        return UIColors.smallText;
      default:
        return UIColors.textLight;
    }
  }

  // List<CharTileDC> charTileTocharTileDC(Map<int, CharTile> charTiles){
  //   charTiles.forEach((key, value) { });
  // }
}
