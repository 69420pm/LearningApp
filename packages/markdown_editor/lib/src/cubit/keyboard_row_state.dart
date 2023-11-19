// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'keyboard_row_cubit.dart';

@immutable
abstract class KeyboardRowState extends Equatable {}

class KeyboardRowText extends KeyboardRowState {
  bool isBold;
  bool isItalic;
  bool isUnderlined;
  Color textColor;
  Color backgroundColor;
  KeyboardRowText({
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  List<Object?> get props => [textColor, backgroundColor, isBold, isItalic, isUnderlined];
}

class KeyboardRowTextColors extends KeyboardRowState {
  @override
  List<Object?> get props => [];
}

class KeyboardRowBackgroundColors extends KeyboardRowState {
  @override
  List<Object?> get props => [];
}

class KeyboardRowNewTile extends KeyboardRowState {
  @override
  List<Object?> get props => [];
}
