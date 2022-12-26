import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:meta/meta.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnState> {
  LearnCubit(this._cardsRepository) : super(FrontState());

  var cardsToLearn = <Card>[];
  var cardsToRepeatFurther = <Card>[];

  final CardsRepository _cardsRepository;

  void turnOverCard() {
    emit(BackState());
  }

  void newCard(LearnFeedback feedbackLastCard, Card card) {
    final currentRecallScore = card.recallScore;
    var nextRecallScore = currentRecallScore;
    var nextTimeToReview = DateTime.now();
    if (feedbackLastCard == LearnFeedback.good) {
      cardsToLearn.removeAt(0);
      nextTimeToReview = nextTimeToReview
          .add(Duration(hours: _getDuration(currentRecallScore)));
      nextRecallScore += 1;
    } else if (feedbackLastCard == LearnFeedback.medium) {
      nextTimeToReview = nextTimeToReview
          .add(Duration(hours: _getDuration((currentRecallScore / 4).round())));
      if (currentRecallScore < 2) {
        cardsToLearn.add(card);
      }
    } else {
      nextRecallScore -= 1;
      if (nextRecallScore < 0) nextRecallScore = 0;
      cardsToLearn
        ..removeAt(0)
        ..add(card);
    }
    final newCard = card.copyWith(
      recallScore: nextRecallScore,
      dateToReview: nextTimeToReview.toIso8601String(),
    );
    _cardsRepository.saveCard(newCard);
    print(newCard);
    emit(FrontState());
  }

  void learnAllCards() {
    cardsToLearn = _cardsRepository.learnAllCards();

    cardsToLearn.sort(
      (a, b) => DateTime.parse(a.dateToReview)
          .compareTo(DateTime.parse(b.dateToReview)),
    );
  }

  Card? getNextCard() {
    if (cardsToLearn.length == 0) return null;
    return cardsToLearn[0];
  }
}

enum LearnFeedback { good, medium, bad }

int _getDuration(int currentRecallScore) {
  final nextTimeToReview = DateTime.now();
  if (currentRecallScore > 4) {
    return 120 * 24;
  }
  switch (currentRecallScore) {
    // 24h later
    case 0:
      return 24;
    // 4 days later
    case 1:
      return 4 * 24;
    // 1 week later
    case 2:
      return 7 * 24;
    // 3 weeks later
    case 3:
      return 21 * 24;

    // 2 months later
    case 4:
      return 60 * 24;
    // 4 months later

    default:
      return 24;
  }
}
