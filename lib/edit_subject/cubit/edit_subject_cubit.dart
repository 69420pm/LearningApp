import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

part 'edit_subject_state.dart';

class EditSubjectCubit extends Cubit<EditSubjectState> {
  EditSubjectCubit(this.cardsRepository) : super(EditSubjectInitial());

  final CardsRepository cardsRepository;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<ClassTest> classTests = [];
  Subject? subject;

  void init(Subject subject) {
    selectedDays = subject.scheduledDays;

    classTests = cardsRepository.getClassTestsBySubjectId(subject.uid) ?? [];
    this.subject = subject;
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }

  Future<void> saveSubject(Subject newSubject) async {
    emit(EditSubjectLoading());
    try {
      subject = newSubject;
      await cardsRepository.saveSubject(newSubject);
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
    await cardsRepository.deleteSubject(subjectId);
    subject = null;
    // } catch (e) {
    //   emit(
    //     EditSubjectFailure(
    //       errorMessage: 'Subject saving failed, while communicating with hive',
    //     ),
    //   );
    // }
  }

  void changeClassTests() {
    classTests = cardsRepository.getClassTestsBySubjectId(subject!.uid) ?? [];
    emit(EditSubjectClassTestChanged(classTests: classTests));
  }

  // Future<void> saveClassTest(
  //   ClassTest classTest,
  // ) async {
  //   await cardsRepository.saveClassTest(subject!.uid, classTest);
  //   final newClassTests = cardsRepository.getClassTests(subject!.uid);
  //   if (newClassTests != null) {
  //     classTests = newClassTests;
  //   }
  //   // classTests = subject!.classTests;
  //   // if (classTests.isEmpty) {
  //   //   classTests.add(classTest);
  //   // }
  //   // for (var i = 0; i < classTests.length; i++) {
  //   //   if (classTests[i].uid == classTest.uid) {
  //   //     classTests[i] = classTest;
  //   //     break;
  //   //   }
  //   //   // if nothing found
  //   //   if (i == classTests.length - 1) {
  //   //     classTests.add(classTest);
  //   //   }
  //   // }

  //   // await saveSubject(subject!.copyWith(classTests: classTests));
  //   // emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  //   // emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  //   emit(EditSubjectSuccess(subject: subject!));
  // }

  // Future<void> deleteClassTest(ClassTest classTest) async {
  //   cardsRepository.deleteClassTest(subject!.uid, classTest.uid);
  //   final newClassTests = cardsRepository.getClassTests(subject!.uid);
  //   if (newClassTests != null) {
  //     classTests = newClassTests;
  //   }
  //   // if (classTests.contains(classTest)) {
  //   //   classTests.remove(classTest);
  //   // }
  //   // await saveSubject(subject!.copyWith(classTests: classTests));
  //   emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  // }

  // Future<void> changeClassTest(ClassTest classTest) async {
  //   if (classTest.name.trim().isNotEmpty) {
  //     await cardsRepository.saveClassTest(subject!.uid, classTest);
  //     final newClassTests = cardsRepository.getClassTests(subject!.uid);
  //     if (newClassTests != null) {
  //       classTests = newClassTests;
  //     }
  //     emit(EditSubjectClassTestChanged(canSave: true, classTest: classTest));
  //   } else {
  //     await cardsRepository.saveClassTest(subject!.uid, classTest);
  //     final newClassTests = cardsRepository.getClassTests(subject!.uid);
  //     if (newClassTests != null) {
  //       classTests = newClassTests;
  //     }
  //     emit(EditSubjectClassTestChanged(canSave: false, classTest: classTest));
  //   }
  // }

  Future<void> updateWeekdays(int idToSwitch) async {
    selectedDays[idToSwitch] = !selectedDays[idToSwitch];
    await saveSubject(subject!.copyWith(scheduledDays: selectedDays));
    emit(EditSubjectUpdateWeekdays(selectedDays: selectedDays));
  }
}
