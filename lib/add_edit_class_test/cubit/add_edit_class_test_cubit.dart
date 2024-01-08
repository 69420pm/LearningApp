import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';

part 'add_edit_class_test_state.dart';

class AddEditClassTestCubit extends Cubit<AddEditClassTestState> {
  AddEditClassTestCubit(
      {required this.cardsRepository,
      required this.parentSubject,
      this.classTest,
      })
      : super(AddEditClassTestInitial(classTest: classTest)) {
    classTest ??= ClassTest(
      uid: Uid().uid(),
      name: 'New Class Test',
      date: DateTime.now(),
      folderIds: const [],
    );
    cardsRepository.saveClassTest(parentSubject.uid, classTest!);
  }
  CardsRepository cardsRepository;
  ClassTest? classTest;
  Subject parentSubject;

  Future<void> changeDate(DateTime date) async {
    classTest = classTest!.copyWith(date: date);
    await cardsRepository.saveClassTest(parentSubject.uid, classTest!);
    emit(AddEditClassTestChangedDate(date: classTest!.date));
  }

  Future<void> changeName(String name) async {
    classTest = classTest!.copyWith(name: name);
    await cardsRepository.saveClassTest(parentSubject.uid, classTest!);
  }

  Future<void> changeRelevantCards(List<String> relevantCards) async {
    classTest = classTest!.copyWith(folderIds: relevantCards);
    await cardsRepository.saveClassTest(parentSubject.uid, classTest!);
    emit(
      AddEditClassTestChangedRelevantCards(
        relevantCardsLength: classTest!.folderIds.length,
      ),
    );
  }

  Future<void> deleteClassTest() async {
    await cardsRepository.deleteClassTest(parentSubject.uid);
  }
}
