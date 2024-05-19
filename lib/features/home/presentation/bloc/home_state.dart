part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<String> subjectIds;
  const HomeSuccess({required this.subjectIds});
  @override
  List<Object> get props => [subjectIds];
}
