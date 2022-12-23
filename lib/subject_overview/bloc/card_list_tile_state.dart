// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'card_list_tile_bloc.dart';

abstract class CardListTileState {}

class CardListTileInitial extends CardListTileState {}

class CardListTileLoading extends CardListTileState {}

class CardListTileSuccess extends CardListTileState {}

class CardListTileSelected extends CardListTileState {}

class CardListTileUnselected extends CardListTileState {}

class CardListTileError extends CardListTileState {
  String errorMessage;
  CardListTileError({
    required this.errorMessage,
  });
}
