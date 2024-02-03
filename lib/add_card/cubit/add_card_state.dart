// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_card_cubit.dart';

@immutable
abstract class AddCardState {}

class AddCardInitial extends AddCardState {}

class AddCardLoading extends AddCardState {}

class AddCardSuccess extends AddCardState {}

class AddCardFailure extends AddCardState {
  AddCardFailure({
    required this.errorMessage,
  });
  String errorMessage;
}

class AddCardFocusedTileChanged extends AddCardState {
  EditorTileType type;
  AddCardFocusedTileChanged({
    required this.type,
  });

}
