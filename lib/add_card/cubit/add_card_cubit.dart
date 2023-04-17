import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:meta/meta.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit(this._cardsRepository) : super(AddCardInitial());

  final CardsRepository _cardsRepository;
  bool _editMarkDownMode = false;

  Future<void> saveCard(
    String front,
    String back,
    Subject parentSubject,
    String icon,
  ) async {
    emit(AddCardLoading());
    final newCard = Card(
      id: Uid().uid(),
      front: front,
      back: back,
      dateCreated: DateTime.now().toIso8601String(),
      parentId: parentSubject.id,
      askCardsInverted: false,
      typeAnswer: true,
      dateToReview: DateTime.now().toIso8601String(),
      tags: const [],
    );
    try {
      // parentSubject.childCards.add(newCard);
      await _cardsRepository.saveCard(newCard);
      emit(AddCardSuccess());
    } catch (e) {
      emit(
        AddCardFailure(
          errorMessage: 'Card saving failed, while communicating with hive',
        ),
      );
    }
  }

  void switchMarkdownMode() {
    if (_editMarkDownMode) {
      emit(AddCardRenderMode());
    } else {
      emit(AddCardEditMode());
    }
    _editMarkDownMode = !_editMarkDownMode;
  }
}
