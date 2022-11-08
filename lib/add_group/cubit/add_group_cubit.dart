import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_group_state.dart';

class AddGroupCubit extends Cubit<AddGroupState> {
  AddGroupCubit(this._cardsRepository) : super(AddGroupInitial());

  final CardsRepository _cardsRepository;

  Future<void> addGroup(String name) async {
    emit(AddGroupLoading());
    final id = const Uuid().v4();
    final newGroup = Group(
      id: id,
      name: name,
      dateCreated: DateTime.now().toString(),
    );
    try {
      print(newGroup.toString());
      await _cardsRepository.saveGroup(newGroup);
      emit(AddGroupSuccess());
    } catch (e) {
      print(e);
      emit(AddGroupFailed('communication with backend failed'));
    }
  }
}
