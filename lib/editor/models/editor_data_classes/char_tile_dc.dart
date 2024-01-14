// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'char_tile_dc.g.dart';

@HiveType(typeId: 5)
class CharTileDC extends Equatable {
  /// text of charTile
  @HiveField(0)
  String text;

  // start index of text sequence
  @HiveField(1)
  int start;

  // end index of text sequence
  @HiveField(2)
  int end;

  /// whether text is bold
  @HiveField(3)
  bool isBold;

  /// whether text is italic
  @HiveField(4)
  bool isItalic;

  /// whether text is underlined
  @HiveField(5)
  bool isUnderlined;

  // color as int (0:white, 1:red,2:yellow,3:green,4:blue,5:purple)
  @HiveField(6)
  int color;

  @HiveField(7)
  String uid;
  
  // color as int (0:white, 1:red,2:yellow,3:green,4:blue,5:purple)
  @HiveField(8)
  int backgroundColor;
  
  CharTileDC({
    required this.text,
    required this.start,
    required this.end,
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
    required this.color,
    required this.uid,
    required this.backgroundColor,
  });

  @override
  List<Object?> get props =>
      [text, start, end, isBold, isItalic, isUnderlined, color, backgroundColor];
}
