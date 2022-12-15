// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'card_list_tile_bloc.dart';

@immutable
abstract class CardListTileEvent {}

class CardListTileDeleteCard extends CardListTileEvent {
  String id;
  String parentId;
  CardListTileDeleteCard({
    required this.id,
    required this.parentId,
  });
}
