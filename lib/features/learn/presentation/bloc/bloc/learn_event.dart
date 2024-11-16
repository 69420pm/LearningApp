part of 'learn_bloc.dart';

sealed class LearnEvent extends Equatable {
  const LearnEvent();

  @override
  List<Object> get props => [];
}

class SetCardsToLearn extends LearnEvent {
  final List<CardModel> cards;

  SetCardsToLearn(this.cards);

  @override
  List<Object> get props => [cards];
}
