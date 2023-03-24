import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'keyboard_row_state.dart';

class KeyboardRowCubit extends Cubit<KeyboardRowState> {
  KeyboardRowCubit() : super(KeyboardRowInitial());
  
}
