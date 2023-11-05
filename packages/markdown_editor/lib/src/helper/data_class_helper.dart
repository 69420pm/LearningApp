import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/audio_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/callout_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/char_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/divider_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/front_back_seperator_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/header_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/image_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/latex_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/list_editor_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/quote_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/text_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_tile.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/models/text_field_controller.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/audio_tile.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/header_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/image_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/latex_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/quote_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:ui_components/ui_components.dart';
import 'package:markdown_editor/src/models/editor_data_classes/char_tile_dc.dart';

class DataClassHelper {
  static List<EditorTileDC> convertToDataClass(List<EditorTile> editorTiles) {
    final dataClassTiles = <EditorTileDC>[];
    for (final editorTile in editorTiles) {
      switch (editorTile.runtimeType) {
        case AudioTile:
          dataClassTiles.add(
            AudioTileDC(
              uid: Uid().uid(),
              filePath: (editorTile as AudioTile).filePath,
            ),
          );
          break;
        case CalloutTile:
          final calloutTile = editorTile as CalloutTile;
          dataClassTiles.add(
            CalloutTileDC(
              uid: Uid().uid(),
              charTiles: _charTileToCharTileDC(
                calloutTile.textFieldController!.charTiles,
              ),
              tileColor: _colorToInt(calloutTile.tileColor),
              iconString: calloutTile.iconString,
            ),
          );
          break;
        case DividerTile:
          dataClassTiles.add(DividerTileDC(uid: Uid().uid()));
          break;
        case HeaderTile:
          final headerTile = editorTile as HeaderTile;
          dataClassTiles.add(
            HeaderTileDC(
              uid: Uid().uid(),
              charTiles: headerTile.textFieldController != null
                  ? _charTileToCharTileDC(
                      headerTile.textFieldController!.charTiles,
                    )
                  : [],
              headerSize:
                  headerTile.textStyle == TextFieldConstants.headingBig ? 1 : 0,
            ),
          );
          break;

        case ImageTile:
          final imageTile = editorTile as ImageTile;
          dataClassTiles.add(
            ImageTileDC(
              uid: Uid().uid(),
              filePath: imageTile.image.path,
              scale: imageTile.scale,
              alignment: _alignmentToInt(imageTile.alignment),
            ),
          );
          break;

        case LatexTile:
          final latexTile = editorTile as LatexTile;
          dataClassTiles.add(
            LatexTileDC(uid: Uid().uid(), latexText: latexTile.latexText),
          );
          break;

        case ListEditorTile:
          final listEditorTile = editorTile as ListEditorTile;
          dataClassTiles.add(
            ListEditorTileDC(
              uid: Uid().uid(),
              charTiles: _charTileToCharTileDC(
                listEditorTile.textFieldController!.charTiles,
              ),
              orderNumber: listEditorTile.orderNumber,
            ),
          );
          break;

        case QuoteTile:
          final quoteTile = editorTile as QuoteTile;
          dataClassTiles.add(
            QuoteTileDC(
              uid: Uid().uid(),
              charTiles: _charTileToCharTileDC(
                quoteTile.textFieldController!.charTiles,
              ),
            ),
          );
          break;

        case TextTile:
          final textTile = editorTile as TextTile;
          dataClassTiles.add(
            TextTileDC(
              uid: Uid().uid(),
              charTiles: _charTileToCharTileDC(
                textTile.textFieldController!.charTiles,
              ),
            ),
          );
          break;
        case FrontBackSeparatorTile:
          dataClassTiles.add(FrontBackSeparatorTileDC(uid: Uid().uid()));
          break;
        default:
      }
    }
    return dataClassTiles;
  }

  static List<EditorTile> convertFromDataClass(
    List<dynamic> editorTilesDC,
  ) {
    final dataClassTiles = <EditorTile>[];
    for (final editorTileDC in editorTilesDC) {
      switch (editorTileDC.runtimeType) {
        case AudioTileDC:
          final audioTile = editorTileDC as AudioTileDC;
          dataClassTiles.add(AudioTile(filePath: audioTile.filePath));
          break;
        case CalloutTileDC:
          final calloutTileDC = editorTileDC as CalloutTileDC;
          dataClassTiles.add(
            CalloutTile(
              textTile: TextTile(
                textStyle: TextFieldConstants.normal,
                charTiles: _charTileDCToCharTile(
                  calloutTileDC.charTiles,
                  TextFieldConstants.normal,
                ),
              ),
              tileColor: _intToColor(calloutTileDC.tileColor),
              iconString: calloutTileDC.iconString,
            ),
          );
          break;
        case DividerTileDC:
          dataClassTiles.add(DividerTile());
          break;
        case HeaderTileDC:
          final headerTileDC = editorTileDC as HeaderTileDC;
          final textStyle = headerTileDC.headerSize == 1
              ? TextFieldConstants.headingBig
              : TextFieldConstants.headingSmall;
          dataClassTiles.add(
            HeaderTile(
              textStyle: textStyle,
              hintText: headerTileDC.headerSize == 1
                  ? 'Heading big'
                  : 'Heading small',
              charTiles: _charTileDCToCharTile(
                headerTileDC.charTiles,
                textStyle,
              ),
            ),
          );
          break;

        case ImageTileDC:
          final imageTile = editorTileDC as ImageTileDC;
          dataClassTiles.add(
            ImageTile(
              image: File(imageTile.filePath),
              scale: imageTile.scale,
              alignment: _intToAlignment(imageTile.alignment),
            ),
          );
          break;

        case LatexTileDC:
          final latexTile = editorTileDC as LatexTileDC;
          dataClassTiles.add(
            LatexTile(latexText: latexTile.latexText),
          );
          break;

        case ListEditorTileDC:
          final listEditorTile = editorTileDC as ListEditorTileDC;
          dataClassTiles.add(
            ListEditorTile(
              charTiles: _charTileDCToCharTile(
                listEditorTile.charTiles,
                TextFieldConstants.normal,
              ),
              orderNumber: listEditorTile.orderNumber,
            ),
          );
          break;

        case QuoteTileDC:
          final quoteTile = editorTileDC as QuoteTileDC;
          dataClassTiles.add(
            QuoteTile(
              charTiles: _charTileDCToCharTile(
                quoteTile.charTiles,
                TextFieldConstants.quote,
              ),
            ),
          );
          break;

        case TextTileDC:
          final textTile = editorTileDC as TextTileDC;
          dataClassTiles.add(
            TextTile(
              charTiles: _charTileDCToCharTile(
                textTile.charTiles,
                TextFieldConstants.normal,
              ),
              textStyle: TextFieldConstants.normal,
            ),
          );
          break;
        case FrontBackSeparatorTileDC:
          dataClassTiles.add(FrontBackSeparatorTile());
          break;
        // Add more cases for other tile types if needed
        default:
        // Handle the default case, if any
      }
    }
    return dataClassTiles;
  }

  static List<String> getFrontAndBackText(List<EditorTileDC> tiles, bool onlyFront) {
    var front = '';
    var back = '';
    var addFront = true;
    for (final tile in tiles) {
      if (tile is TextTileDC) {
        final text = _charTilesToText(tile.charTiles);
        addFront ? front += '$text\n' : back += '$text\n';
      } else if (tile is HeaderTileDC) {
        final text = _charTilesToText(tile.charTiles);
        addFront ? front += '$text\n' : back += '$text\n';
      } else if (tile is CalloutTileDC) {
        final text = _charTilesToText(tile.charTiles);
        addFront ? front += '$text\n' : back += '$text\n';
      } else if (tile is ListEditorTileDC) {
        final text = _charTilesToText(tile.charTiles);
        addFront ? front += '$text\n' : back += '$text\n';
      } else if (tile is QuoteTileDC) {
        final text = _charTilesToText(tile.charTiles);
        addFront ? front += '$text\n' : back += '$text\n';
      } else if (tile is FrontBackSeparatorTileDC) {
        if(onlyFront){
          return [front];
        }
        addFront = false;
      }
    }
    return [front, back];
  }

  static String _charTilesToText(List<CharTileDC> charTiles) {
    var text = '';
    for (final element in charTiles) {
      text += element.text;
    }
    return text;
  }

  // make color storable
  static int _colorToInt(Color? color) {
    if (color == null) {
      return 0;
    }
    if (color == UIColors.textLight) {
      return 0;
    } else if (color == UIColors.red) {
      return 1;
    } else if (color == UIColors.yellow) {
      return 2;
    } else if (color == UIColors.green) {
      return 3;
    } else if (color == UIColors.blue) {
      return 4;
    } else if (color == UIColors.purple) {
      return 5;
    } else if (color == UIColors.smallText) {
      return 6;
    } else if (color == UIColors.smallTextDark) {
      return 7;
    } else if (color == UIColors.redTransparent) {
      return 8;
    } else if (color == UIColors.yellowTransparent) {
      return 9;
    } else if (color == UIColors.greenTransparent) {
      return 10;
    } else if (color == UIColors.blueTransparent) {
      return 11;
    } else if (color == UIColors.purpleTransparent) {
      return 12;
    } else if (color == Colors.transparent) {
      return 13;
    } else {
      return 0;
    }
  }

  // convert stored color back to color
  static Color _intToColor(int i) {
    if (i == 0) {
      return UIColors.textLight;
    } else if (i == 1) {
      return UIColors.red;
    } else if (i == 2) {
      return UIColors.yellow;
    } else if (i == 3) {
      return UIColors.green;
    } else if (i == 4) {
      return UIColors.blue;
    } else if (i == 5) {
      return UIColors.purple;
    } else if (i == 6) {
      return UIColors.smallText;
    } else if (i == 7) {
      return UIColors.smallTextDark;
    } else if (i == 8) {
      return UIColors.redTransparent;
    } else if (i == 9) {
      return UIColors.yellowTransparent;
    } else if (i == 10) {
      return UIColors.greenTransparent;
    } else if (i == 11) {
      return UIColors.blueTransparent;
    } else if (i == 12) {
      return UIColors.purpleTransparent;
    } else if (i == 13) {
      return Colors.transparent;
    } else {
      return UIColors.textLight;
    }
  }

  static int _alignmentToInt(Alignment alignment) {
    if (alignment == Alignment.centerLeft) {
      return 0;
    }
    if (alignment == Alignment.center) {
      return 1;
    }
    if (alignment == Alignment.centerRight) {
      return 2;
    }
    return 1;
  }

  static Alignment _intToAlignment(int i) {
    if (i == 0) {
      return Alignment.centerLeft;
    }
    if (i == 1) {
      return Alignment.center;
    }
    if (i == 2) {
      return Alignment.centerRight;
    }
    return Alignment.center;
  }

  static List<CharTileDC> _charTileToCharTileDC(Map<int, CharTile> charTiles) {
    final charTilesDC = <String, CharTileDC>{};
    CharTile? previousCharTile;
    CharTileDC? previousCharTileDC;
    charTiles.forEach((key, value) {
      if (previousCharTile != null) {
        // if both are equal except of text
        if (_compareCharTiles(previousCharTile!, value) &&
            previousCharTileDC != null) {
          previousCharTileDC!
            ..end = key
            ..text = previousCharTileDC!.text + value.text;
          charTilesDC[previousCharTileDC!.uid] = previousCharTileDC!;
        } else {
          previousCharTileDC = CharTileDC(
            text: value.text,
            start: key,
            end: key,
            isBold: value.isBold,
            isItalic: value.isItalic,
            isUnderlined: value.isUnderlined,
            color: _colorToInt(value.style.color),
            backgroundColor: _colorToInt(value.style.backgroundColor),
            uid: Uid().uid(),
          );
          charTilesDC[previousCharTileDC!.uid] = previousCharTileDC!;
        }
      } else {
        previousCharTileDC = CharTileDC(
          text: value.text,
          start: key,
          end: key,
          isBold: value.isBold,
          isItalic: value.isItalic,
          isUnderlined: value.isUnderlined,
          color: _colorToInt(value.style.color),
          backgroundColor: _colorToInt(value.style.backgroundColor),
          uid: Uid().uid(),
        );
        charTilesDC[previousCharTileDC!.uid] = previousCharTileDC!;
      }
      previousCharTile = value;
    });
    return charTilesDC.values.toList();
  }

  static Map<int, CharTile> _charTileDCToCharTile(
    List<CharTileDC> charTilesDC,
    TextStyle style,
  ) {
    final charTiles = <int, CharTile>{};
    for (final charTileDC in charTilesDC) {
      for (var i = charTileDC.start; i <= charTileDC.end; i++) {
        charTiles[i] = CharTile(
          text: charTileDC.text
              .substring(i - charTileDC.start, i - charTileDC.start + 1),
          style: style.copyWith(
            color: _intToColor(charTileDC.color),
            backgroundColor: _intToColor(charTileDC.backgroundColor),
          ),
          isBold: charTileDC.isBold,
          isItalic: charTileDC.isItalic,
          isUnderlined: charTileDC.isUnderlined,
        );
      }
    }
    return charTiles;
  }

  static bool _compareCharTiles(CharTile a, CharTile b) {
    return a.isBold == b.isBold &&
        a.isItalic == b.isItalic &&
        a.isHyperlink == b.isHyperlink &&
        a.isUnderlined == b.isUnderlined &&
        a.style == b.style;
  }
}
