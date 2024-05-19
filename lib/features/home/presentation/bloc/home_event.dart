// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeSubjectWatchChildrenIds extends HomeEvent {}

class HomeSubjectAddSubject extends HomeEvent {
  final String name;
  const HomeSubjectAddSubject({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
