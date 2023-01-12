import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._cardsRepository) : super(SearchInitial()) {

    on<SearchRequest>(request);
  }

  final CardsRepository _cardsRepository;

  FutureOr<void> request(SearchRequest event, Emitter<SearchState> emit) {
    emit(SearchLoading());
    final cards = _cardsRepository.search(event.searchRequest);
    final tiles = <CardListTileView>[];
    for (final card in cards) {
      tiles.add(
        CardListTileView(
          card: card,
          isSelected: false,
          height: 40,
        ),
      );
    }
    emit(
      SearchSuccess(
        foundCards: tiles,
      ),
    );
  }
}
