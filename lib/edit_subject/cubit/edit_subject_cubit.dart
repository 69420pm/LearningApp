import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

part 'edit_subject_state.dart';

class EditSubjectCubit extends Cubit<EditSubjectState> {
  EditSubjectCubit(this._cardsRepository) : super(EditSubjectInitial());

  final CardsRepository _cardsRepository;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<ClassTest> classTests = [];
  Subject? subject;

  void init(Subject subject) {
    selectedDays = subject.scheduledDays;
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

  Future<void> deleteSubject(String subjectId) async {
    emit(EditSubjectLoading());

    // try {
    await _cardsRepository.deleteSubject(subjectId);
    subject = null;
    // } catch (e) {
    //   emit(
    //     EditSubjectFailure(
    //       errorMessage: 'Subject saving failed, while communicating with hive',
    //     ),
    //   );
    // }
  }

  Future<void> saveClassTest(
    ClassTest classTest,
  ) async {
    classTests = subject!.classTests;
    if (classTests.isEmpty) {
      classTests.add(classTest);
    }
    for (var i = 0; i < classTests.length; i++) {
      if (classTests[i].uid == classTest.uid) {
        classTests[i] = classTest;
        break;
      }
      // if nothing found
      if (i == classTests.length - 1) {
        classTests.add(classTest);
      }
    }

    await saveSubject(subject!.copyWith(classTests: classTests));
    emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  }

  Future<void> deleteClassTest(ClassTest classTest) async {
    if (classTests.contains(classTest)) {
      classTests.remove(classTest);
    }
    await saveSubject(subject!.copyWith(classTests: classTests));
    emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  }

  void changeClassTest(ClassTest classTest) {
    if (classTest.name != '' && classTest.date != '') {
      emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
    } else if (classTest.date != '') {
      emit(EditSubjectClassTestChanged(canSave: false, classTest: classTest));
    }
  }

  Future<void> updateWeekdays(int idToSwitch) async {
    selectedDays[idToSwitch] = !selectedDays[idToSwitch];
    await saveSubject(subject!.copyWith(scheduledDays: selectedDays));
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }
}
