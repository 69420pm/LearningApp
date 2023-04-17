import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/app/helper/uid.dart';

part 'add_folder_state.dart';

class AddFolderCubit extends Cubit<AddFolderState> {
  AddFolderCubit(this._cardsRepository) : super(AddFolderInitial());

  final CardsRepository _cardsRepository;

  Future<void> saveFolder(
      String name, Subject? parentSubject, Folder? parentFolder,) async {
    emit(AddFolderLoading());
    final String parentId;
    if (parentFolder != null) {
      parentId = parentFolder.id;
    } else if (parentSubject != null) {
      parentId = parentSubject.id;
    } else {
      emit(AddFolderFailure(errorMessage: 'no parent was given'));
      return;
    }
    final newFolder = Folder(
        id: Uid().uid(),
        name: name,
        parentId: parentId,
        dateCreated: DateTime.now().toIso8601String(),
        // childCards: List.empty(growable: true),
        // childFolders: List.empty(growable: true));
    );
    try {
      if (parentFolder != null) {
        // parentFolder.childFolders.add(newFolder);
      } else if (parentSubject != null) {
        // parentSubject.childFolders.add(newFolder);
      }
      await _cardsRepository.saveFolder(newFolder);
      emit(AddFolderSuccess());
    } catch (e) {
      emit(
        AddFolderFailure(
            errorMessage:
                'Subject saving failed, while communicating with hive',),
      );
    }
  }
}
