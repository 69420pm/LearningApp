import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._cardsRepository) : super(SearchInitial()) {
    on<SearchRequest>(request);
  }

  final CardsRepository _cardsRepository;
  String lastSearch = '';

  List<SearchResult> folderSearchResults = [];
  List<SearchResult> cardSearchResults = [];
  List<Subject> subjectSearchResults = [];

  FutureOr<void> request(SearchRequest event, Emitter<SearchState> emit) {
    emit(SearchLoading());
    if(event.searchRequest.isEmpty){
      emit(SearchInitial());
    }
    cardSearchResults = _cardsRepository.searchCard(event.searchRequest);
    subjectSearchResults = _cardsRepository.searchSubject(event.searchRequest);
    folderSearchResults = _cardsRepository.searchFolder(event.searchRequest);

    if(cardSearchResults.isNotEmpty || folderSearchResults.isNotEmpty || subjectSearchResults.isNotEmpty){
      emit(SearchSuccess(searchRequest: event.searchRequest));
    }else{
      emit(SearchNothingFound());
    }
  }

  void resetState(){
    emit(SearchInitial());
  }
}
