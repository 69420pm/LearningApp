// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'folder_bloc.dart';

sealed class FolderState extends Equatable {
  const FolderState();

  @override
  List<Object> get props => [];
}

final class FolderLoading extends FolderState {}

final class FolderError extends FolderState {
  final String errorMessage;

  FolderError({required this.errorMessage});
}

final class FolderSuccess extends FolderState {
  final List<String> ids;

  FolderSuccess({required this.ids});
  @override
  List<Object> get props => ids;
}
