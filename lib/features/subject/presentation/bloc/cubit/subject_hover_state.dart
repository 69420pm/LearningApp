part of 'subject_hover_cubit.dart';

sealed class SubjectHoverState extends Equatable {
  const SubjectHoverState();

  @override
  List<Object> get props => [];
}

final class SubjectHoverChanged extends SubjectHoverState {
  final String newId;

  const SubjectHoverChanged({required this.newId});
  @override
  List<Object> get props => [newId];
}
