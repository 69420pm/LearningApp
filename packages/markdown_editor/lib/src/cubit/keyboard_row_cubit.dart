
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'keyboard_row_state.dart';

class KeyboardRowCubit extends Cubit<KeyboardRowState> {
  KeyboardRowCubit() : super(KeyboardRowFavorites());

  bool _textColors = false;
  bool _extraFormat = false;

  void expandTextColors() {
    _extraFormat = false;
    _textColors = !_textColors;
    _textColors ? emit(KeyboardRowTextColors()) : emit(KeyboardRowFavorites());
  }

  void expandExtraFormat() {
    _textColors = false;
    _extraFormat = !_extraFormat;
    _extraFormat
        ? emit(KeyboardRowExtraFormat())
        : emit(KeyboardRowFavorites());
  }

  void expandAddNewTextTile() {
    _textColors = false;
    _extraFormat = false;
    emit(KeyboardRowNewTextTile());
  }

  void expandFavorites() {
    emit(KeyboardRowFavorites());
  }

  void expandLatex(){
    emit(KeyboardRowLatex());
  }
}
