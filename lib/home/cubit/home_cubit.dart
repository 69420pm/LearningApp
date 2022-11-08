import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeOverview());

  /// set tabs of bottom navbar
  void setTab(int stateIndex) {
    if (stateIndex == 0) {
      emit(HomeOverview());
    } else if (stateIndex == 1) {
      emit(HomeCalendar());
    } else if (stateIndex == 2) {
      emit(HomeSettings());
    }
  }
}
