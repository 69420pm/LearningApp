import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/app/helper/uid.dart';

part 'add_subject_state.dart';

class AddSubjectCubit extends Cubit<AddSubjectState> {
  AddSubjectCubit(this._cardsRepository) : super(AddSubjectInitial());

  final CardsRepository _cardsRepository;
  List<bool> selectedDays = [false, false, false, false, false, false, false];

  Future<void> saveSubject(String name, int icon, List<bool> daysToGetNotified) async {
    emit(AddSubjectLoading());
    final newSubject = Subject(
      uid: Uid().uid(),
      name: name,
      dateCreated: DateTime.now(),
      icon: icon,
      classTests: const [],
      scheduledDays: daysToGetNotified,
      streakRelevant: true,
      disabled: false,
    );
    try {
      await _cardsRepository.saveSubject(newSubject);

      emit(AddSubjectSuccess());
    } catch (e) {
      emit(
        AddSubjectFailure(
          errorMessage: 'Subject saving failed, while communicating with hive',
        ),
      );
    }
  }

  Future<void> deleteSubject(String id) async {
    emit(AddSubjectLoading());
    try {
      await _cardsRepository.deleteSubject(id);
      emit(AddSubjectSuccess());
    } catch (e) {
      emit(AddSubjectFailure(errorMessage: 'Subject deletion failed'));
    }
  }

  void resetWeekDays(){
    selectedDays = [false, false, false, false, false, false, false];
    emit(AddSubjectUpdateWeekdays(selectedDays: selectedDays));
  }

  void updateWeekdays(int idToSwitch){
    selectedDays[idToSwitch] = !selectedDays[idToSwitch];
    emit(AddSubjectUpdateWeekdays(selectedDays: selectedDays));
  }
}
