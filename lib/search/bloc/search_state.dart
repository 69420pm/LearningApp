// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  List<CardListTileView> foundCards;
  SearchSuccess({
    required this.foundCards,
});
}

class SearchFailure extends SearchState {
  String errorMessage;
  SearchFailure({
    required this.errorMessage,
  });
}
