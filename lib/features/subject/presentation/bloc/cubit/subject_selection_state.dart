part of 'subject_selection_cubit.dart';

sealed class SubjectSelectionState extends Equatable {
  const SubjectSelectionState();

  @override
  List<Object> get props => [];
}

final class SubjectSelectionError extends SubjectSelectionState {
  final String errorMessage;

  const SubjectSelectionError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class SubjectSelectionSelectionChanged extends SubjectSelectionState {
  final List<String> changedIds;
  final List<String> selectedIds;
  const SubjectSelectionSelectionChanged({
    required this.selectedIds,
    required this.changedIds,
  });
  @override
  List<Object> get props => [changedIds, selectedIds];
}
