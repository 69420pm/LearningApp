part of 'subject_app_bar_cubit.dart';

sealed class SubjectAppBarState extends Equatable {
  const SubjectAppBarState();

  @override
  List<Object> get props => [];
}

final class SubjectAppBarNothingSelected extends SubjectAppBarState {}

final class SubjectAppBarCardSelected extends SubjectAppBarState {}

final class SubjectAppBarFolderSelected extends SubjectAppBarState {}

final class SubjectAppBarFilesSelected extends SubjectAppBarState {}
