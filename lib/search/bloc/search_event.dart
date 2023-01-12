part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchRequest extends SearchEvent{
  SearchRequest(this.searchRequest);
  String searchRequest;
}
