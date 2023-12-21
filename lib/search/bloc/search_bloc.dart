import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/search_result.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:learning_app/card_backend/cards_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.cardsRepository) : super(SearchInitial()) {
    on<SearchRequest>(request);
  }

  final CardsRepository cardsRepository;
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
    cardSearchResults = cardsRepository.searchCard(
      event.searchRequest.trim().toLowerCase(),
      searchId,
    );
    if (searchId == null || searchId!.isEmpty) {
      subjectSearchResults = cardsRepository
          .searchSubject(event.searchRequest.trim().toLowerCase());
    } else {
      subjectSearchResults = [];
    }
    folderSearchResults = cardsRepository.searchFolder(
      event.searchRequest.trim().toLowerCase(),
      searchId,
    );

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
