// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_folder_cubit.dart';

abstract class AddFolderState {}

class AddFolderInitial extends AddFolderState {}

class AddFolderLoading extends AddFolderState {}

class AddFolderSuccess extends AddFolderState {}

class AddSFolderFailure extends AddFolderState {
  AddSFolderFailure({
    required this.errorMessage,
  });
  String errorMessage;
}
