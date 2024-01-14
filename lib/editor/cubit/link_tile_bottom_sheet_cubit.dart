import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/search_result.dart';
import 'package:meta/meta.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
part 'link_tile_bottom_sheet_state.dart';

class LinkTileBottomSheetCubit extends Cubit<LinkTileBottomSheetState> {
  LinkTileBottomSheetCubit(this.cardsRepository)
      : super(LinkTileBottomSheetInitial());
  final CardsRepository cardsRepository;
  List<SearchResult> cardSearchResults = [];

  FutureOr<void> request(String searchRequest) {
    cardSearchResults = cardsRepository.searchCard(
      searchRequest.trim().toLowerCase(),
      null,
    );

    if (cardSearchResults.isNotEmpty) {
      emit(LinkTileBottomSheetSuccess());
    } else {
      emit(LinkTileBottomSheetNothingFound());
    }
  }

  void resetState() {
    emit(LinkTileBottomSheetInitial());
  }
}
