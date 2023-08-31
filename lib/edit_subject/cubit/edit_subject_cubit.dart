import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_subject_state.dart';

class EditSubjectCubit extends Cubit<EditSubjectState> {
  EditSubjectCubit(this._cardsRepository) : super(EditSubjectInitial());

  final CardsRepository _cardsRepository;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<ClassTest> classTests = [];
  Subject? subject;

  void init(Subject subject) {
    selectedDays = subject.daysToGetNotified;
    classTests = subject.classTests;
    this.subject = subject;
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }

  Future<void> saveSubject(Subject newSubject) async {
    emit(EditSubjectLoading());

    try {
      subject = newSubject;
      await _cardsRepository.saveSubject(newSubject);
      emit(EditSubjectSuccess(subject: subject!));
    } catch (e) {
      emit(
        EditSubjectFailure(
          errorMessage: 'Subject saving failed, while communicating with hive',
        ),
      );
    }
  }

  Future<void> deleteSubject(String subjectId) async{
emit(EditSubjectLoading());

    try {
      await _cardsRepository.deleteSubject(subjectId);
      subject = null;
    } catch (e) {
      emit(
        EditSubjectFailure(
          errorMessage: 'Subject saving failed, while communicating with hive',
        ),
      );
    }
  }

  Future<void> saveClassTest(
    ClassTest classTest,
  ) async {
    classTests = subject!.classTests;
    if(classTests.isEmpty){
      classTests.add(classTest);
    }
    for (var i = 0; i < classTests.length; i++) {
      if (classTests[i].id == classTest.id) {
        classTests[i] = classTest;
        break;
      }
      // if nothing found
      if(i==classTests.length-1){
        classTests.add(classTest);
      }
    }

    await saveSubject(subject!.copyWith(classTests: classTests));
    emit(EditSubjectClassTestChanged(canSave: true));
  }

  Future<void> deleteClassTest(ClassTest classTest) async {
    if(classTests.contains(classTest)){
      classTests.remove(classTest);
    }
    await saveSubject(subject!.copyWith(classTests: classTests));
    emit(EditSubjectClassTestChanged(canSave: true));
  }

  void changeClassTest(ClassTest classTest) {
    if (classTest.name != '' && classTest.date != '') {
      emit(EditSubjectClassTestChanged(canSave: true));
    } else if (classTest.date != '') {
      emit(EditSubjectClassTestChanged(canSave: false));
    }
  }

  Future<void> updateWeekdays(int idToSwitch) async {
    selectedDays[idToSwitch] = !selectedDays[idToSwitch];
    await saveSubject(subject!.copyWith(daysToGetNotified: selectedDays));
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }

  void changeCanSave(bool canSave) {
    emit(EditSubjectClassTestChanged(canSave: canSave));
  }
}
