// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  String searchRequest;
  SearchSuccess({
    required this.searchRequest,
  });
}

class SearchNothingFound extends SearchState {}

class SearchFailure extends SearchState {
  String errorMessage;
  SearchFailure({
    required this.errorMessage,
  });
}
