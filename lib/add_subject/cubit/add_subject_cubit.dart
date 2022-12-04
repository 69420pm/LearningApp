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
        dateCreated: DateTime.now().toIso8601String(),
        prefixIcon: icon,
        // childCards: List.empty(growable: true),
        // childFolders: List.empty(growable: true),
        classTests: List<String>.empty(growable: true),
        daysToGetNotified: List<String>.empty(growable: true));
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