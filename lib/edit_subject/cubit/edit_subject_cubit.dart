import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';

part 'edit_subject_state.dart';

class EditSubjectCubit extends Cubit<EditSubjectState> {
  EditSubjectCubit(this._cardsRepository) : super(EditSubjectInitial());

  final CardsRepository _cardsRepository;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<ClassTest> classTests = []; 

  void init(Subject subject) {
    selectedDays = subject.daysToGetNotified;
    classTests = subject.classTests;
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }

  Future<void> saveSubject(Subject newSubject) async {
    emit(EditSubjectLoading());

    try {
      await _cardsRepository.saveSubject(newSubject);

      // emit(EditSubjectSuccess());
    } catch (e) {
      emit(
        EditSubjectFailure(
          errorMessage: 'Subject saving failed, while communicating with hive',
        ),
      );
    }
  }

  Future<void> saveClassTest(ClassTest classTest, Subject subject) async {
    classTests = subject.classTests;
    for (var element in classTests) {
      if(element.id == classTest.id){
        element = classTest;
        break;
      }
    }
    await saveSubject(subject.copyWith(classTests: classTests));
  }

  Future<void> updateWeekdays(int idToSwitch, Subject subject) async {
    selectedDays[idToSwitch] = !selectedDays[idToSwitch];
    await saveSubject(subject.copyWith(daysToGetNotified: selectedDays));
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }
}
