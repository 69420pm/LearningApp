import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'edit_subject_state.dart';

class EditSubjectCubit extends Cubit<EditSubjectState> {
  EditSubjectCubit(this._cardsRepository) : super(EditSubjectInitial());

  final CardsRepository _cardsRepository;

  Future<void> saveSubject(String name, String parentId, String icon) async {
    emit(EditSubjectLoading());
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
      emit(EditSubjectSuccess());
    } catch (e) {
      emit(
        EditSubjectFailure(
            errorMessage:
                'Subject saving failed, while communicating with hive'),
      );
    }
  }
}
