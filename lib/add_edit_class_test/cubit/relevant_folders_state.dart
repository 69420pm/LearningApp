// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'relevant_folders_cubit.dart';

@immutable
sealed class RelevantFoldersState extends Equatable {}

final class RelevantFoldersInitial extends RelevantFoldersState {
  @override
  List<Object?> get props => [];
}

class RelevantFoldersUpdateCheckbox extends RelevantFoldersState {
  Map<String, bool?> files;
  RelevantFoldersUpdateCheckbox({
    required this.files,
  });

  @override
  List<Object?> get props => [files];
}
