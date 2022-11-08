part of 'add_group_cubit.dart';

abstract class AddGroupState {}

class AddGroupInitial extends AddGroupState {}

class AddGroupLoading extends AddGroupState {}

class AddGroupSuccess extends AddGroupState {}

class AddGroupFailed extends AddGroupState {
  AddGroupFailed(this.errorMessage);
  String errorMessage;
}
