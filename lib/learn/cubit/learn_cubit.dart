import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnState> {
  LearnCubit(this._cardsRepository) : super(FrontState());

  final CardsRepository _cardsRepository;

  void turnOverCard() {
    emit(BackState());
  }

  void newCard(int ratingLastCard) {
    emit(FrontState());
  }

  void learnAllCards(){
    _cardsRepository.learnAllCards();
  }
}
