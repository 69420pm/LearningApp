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
  final List<String> selectedIds;
  final List<String> previouslySelectedIds;
  const SubjectSelectionSelectionChanged({
    required this.selectedIds,
    required this.previouslySelectedIds,
  });
  @override
  List<Object> get props => [
        selectedIds,
        previouslySelectedIds,
      ];
}
