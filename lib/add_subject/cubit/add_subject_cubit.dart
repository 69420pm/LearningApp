import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_subject_state.dart';

class AddSubjectCubit extends Cubit<AddSubjectState> {
  AddSubjectCubit(this._cardsRepository) : super(AddSubjectInitial());

  final CardsRepository _cardsRepository;

  Future<void> saveSubject(String name, String parentId, String icon) async {
    emit(AddSubjectLoading());
    final newSubject = Subject(
        id: const Uuid().v4(),
        name: name,
        parentSubjectId: parentId,
        dateCreated: DateTime.now().toIso8601String(),
        prefixIcon: icon,
        classTests: List<String>.empty(),
        daysToGetNotified: List<String>.empty());
    try {
      await _cardsRepository.saveSubject(newSubject);
      emit(AddSubjectSuccess());
    } catch (e) {
      emit(
        AddSubjectFailure(
            errorMessage:
                'Subject saving failed, while communicating with hive'),
      );
    }
  }
}
