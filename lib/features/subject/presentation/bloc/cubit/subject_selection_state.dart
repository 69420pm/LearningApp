part of 'subject_selection_cubit.dart';

sealed class SubjectSelectionState extends Equatable {
  const SubjectSelectionState();

  @override
  List<Object> get props => [];
}

final class SubjectSelectionInitial extends SubjectSelectionState {}

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
