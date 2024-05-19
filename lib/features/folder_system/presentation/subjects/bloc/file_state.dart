// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

final class FileLoading extends FileState {}

final class FileError extends FileState {
  final String errorMessage;

  FileError({required this.errorMessage});
}

final class FileSuccess extends FileState {
  final List<String> ids;

  FileSuccess({required this.ids});
  @override
  List<Object> get props => ids;
}
