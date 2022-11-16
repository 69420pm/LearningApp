import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_folder_state.dart';

class AddFolderCubit extends Cubit<AddFolderState> {
  AddFolderCubit(this._cardsRepository) : super(AddFolderInitial());

  final CardsRepository _cardsRepository;

  ///Todo kein plan was hier hin kommt
  // Future<void> saveSubject(String name, String parentId, String icon) async {
  //   emit(AddFolderLoading());
  //   final newSubject = Subject(
  //       id: const Uuid().v4(),
  //       name: name,
  //       parentSubjectId: parentId,
  //       dateCreated: DateTime.now().toIso8601String(),
  //       prefixIcon: icon,
  //       classTests: List<String>.empty(),
  //       daysToGetNotified: List<String>.empty());
  //   try {
  //     await _cardsRepository.saveSubject(newSubject);
  //     emit(AddFolderSuccess());
  //   } catch (e) {
  //     emit(
  //       AddSFolderFailure(
  //           errorMessage:
  //               'Subject saving failed, while communicating with hive'),
  //     );
  //   }
  // }
}
