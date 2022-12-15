import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';

part 'card_list_tile_event.dart';
part 'card_list_tile_state.dart';

class CardListTileBloc extends Bloc<CardListTileEvent, CardListTileState> {
  CardListTileBloc(this._cardsRepository) : super(CardListTileInitial()) {
    on<CardListTileDeleteCard>((event, emit) async {
      await _deleteCard(event, emit);
    });
  }
  CardsRepository _cardsRepository;

  Future<void> _deleteCard(
      CardListTileDeleteCard event, Emitter<CardListTileState> emit) async {
    emit(CardListTileLoading());
    await _cardsRepository.deleteCard(event.id, event.parentId);
    emit(CardListTileSuccess());
  }
}
