part of 'learn_bloc.dart';

sealed class LearnState extends Equatable {
  const LearnState();
  
  @override
  List<Object> get props => [];
}

final class LearnInitial extends LearnState {}
