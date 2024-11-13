part of 'streak_cubit.dart';

sealed class StreakState extends Equatable {
  const StreakState();

  @override
  List<Object> get props => [];
}

final class StreakInitial extends StreakState {}

final class StreakLoading extends StreakState {}

final class StreakLoaded extends StreakState {}

final class StreakError extends StreakState {
  final String errorMessage;

  StreakError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class StreakSaved extends StreakState {}

final class StreakDeleted extends StreakState {}
