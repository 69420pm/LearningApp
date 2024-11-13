import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  Failure({this.errorMessage = "no error given"});
  @override
  List<Object?> get props => [];
}

class FileNotFoundFailure extends Failure {
  @override
  final String errorMessage;

  FileNotFoundFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class ParentIdNotFoundFailure extends Failure {
  @override
  final String errorMessage;

  ParentIdNotFoundFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class FileDeletionFailure extends Failure {
  @override
  final String errorMessage;

  FileDeletionFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class LocalStorageFailure extends Failure {
  @override
  final String errorMessage;

  LocalStorageFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class ImagePickingFailure extends Failure {
  @override
  final String errorMessage;

  ImagePickingFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class ImageCroppingFailure extends Failure {
  @override
  final String errorMessage;

  ImageCroppingFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}

class StreakNotFoundFailure extends Failure {
  @override
  final String errorMessage;

  StreakNotFoundFailure({required this.errorMessage})
      : super(errorMessage: errorMessage);
}
