import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'relevant_folders_state.dart';

class RelevantFoldersCubit extends Cubit<RelevantFoldersState> {
  RelevantFoldersCubit(this._cardsRepository, this._subject, this._classTest)
      : super(RelevantFoldersInitial()) {
    final ids = _cardsRepository.getChildrenList(_subject.uid);

    for (var id in ids) {
      if(_classTest.folderIds.contains(id)){
        files[id] = true;
      }else{
        files[id] = false;
      }
    }
  }

  final Subject _subject;
  final ClassTest _classTest;
  final CardsRepository _cardsRepository;

  Map<String, bool?> files = {};

  void changeCheckbox(String id, bool? value) {
    files[id] = value;
    emit(RelevantFoldersUpdateCheckbox(files: Map.of(files)));
  }
}
