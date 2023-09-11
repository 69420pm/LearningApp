import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._cardsRepository) : super(SearchInitial()) {
    on<SearchRequest>(request);
  }

  final CardsRepository _cardsRepository;
  String lastSearch = '';
  String? searchId;

  List<SearchResult> folderSearchResults = [];
  List<SearchResult> cardSearchResults = [];
  List<Subject> subjectSearchResults = [];

  FutureOr<void> request(SearchRequest event, Emitter<SearchState> emit) {
    emit(SearchLoading());
    if (event.searchRequest.isEmpty) {
      emit(SearchInitial());
    }
    cardSearchResults =
        _cardsRepository.searchCard(event.searchRequest, searchId);
    if (searchId == null || searchId!.isEmpty) {
      subjectSearchResults =
          _cardsRepository.searchSubject(event.searchRequest);
      
    }else{
      subjectSearchResults = [];
    }
    folderSearchResults =
        _cardsRepository.searchFolder(event.searchRequest, searchId);

    if (cardSearchResults.isNotEmpty ||
        folderSearchResults.isNotEmpty ||
        subjectSearchResults.isNotEmpty) {
      emit(SearchSuccess(searchRequest: event.searchRequest));
    } else {
      emit(SearchNothingFound());
    }
  }

  void resetState() {
    emit(SearchInitial());
  }
}
