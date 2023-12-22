import 'package:bloc/bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnState> {
  LearnCubit(this._cardsRepository) : super(FrontState());

  List<String> cardsToLearn = List.empty(growable: true);
  //how many cards got turned
  int progress = 0;
  final CardsRepository _cardsRepository;

  void turnOverCard(int index) {
    if (state is! BackState) emit(BackState());
    progress = index;
  }

  void newCard() {
    emit(FrontState());
  }

  void learnAllCards() {
    cardsToLearn = _cardsRepository.learnAllCards();

    // cardsToLearn.sort(
    //   (a, b) => a.dateToReview.compareTo(b.dateToReview),
    // );
  }

  // void newCard(LearnFeedback feedbackLastCard, String cardUID) {
  //   Card card = _cardsRepository.objectFromId(cardUID) as Card;
  //   var nextRecallScore = card.recallScore;
  //   var nextTimeToReview = DateTime.now();
  //   // GOOD
  //   if (feedbackLastCard == LearnFeedback.good) {
  //     cardsToLearn.removeAt(0);
  //     nextTimeToReview = nextTimeToReview
  //         .add(Duration(seconds: _getDuration(nextRecallScore)));
  //     nextRecallScore += 1;
  //   }
  //   // MEDIUM
  //   else if (feedbackLastCard == LearnFeedback.medium) {
  //     cardsToLearn.removeAt(0);
  //     nextRecallScore -= 1;
  //     if (nextRecallScore == 0) {
  //       nextRecallScore = 0;
  //     }
  //     nextTimeToReview = nextTimeToReview
  //         .add(Duration(seconds: _getDuration((nextRecallScore / 4).round())));
  //     if (nextRecallScore < 2) {
  //       final newCard = card.copyWith(
  //         recallScore: nextRecallScore,
  //         dateToReview: nextTimeToReview,
  //       );
  //       cardsToLearn.add(newCard);
  //     }
  //   }
  //   // BAD
  //   else {
  //     cardsToLearn.removeAt(0);
  //     nextRecallScore = 0;
  //     nextTimeToReview = DateTime.now();
  //     final newCard = card.copyWith(
  //       recallScore: nextRecallScore,
  //       dateToReview: nextTimeToReview,
  //     );
  //     cardsToLearn.add(newCard);
  //   }
  //   final newCard = card.copyWith(
  //     recallScore: nextRecallScore,
  //     dateToReview: nextTimeToReview,
  //   );
  //   print('card alla');
  //   print(nextRecallScore);
  //   print(nextTimeToReview);
  //   _cardsRepository.saveCard(newCard, null, null);
  //   emit(FrontState());
  // }

  // Card? getNextCard() {
  //   if (cardsToLearn.isEmpty) return null;
  //   return cardsToLearn[0];
  // }
}

// enum LearnFeedback { good, medium, bad }

// int _getDuration(int currentRecallScore) {
//   final nextTimeToReview = DateTime.now();
//   if (currentRecallScore > 5) {
//     return 120 * 24;
//   }
//   switch (currentRecallScore) {
//     // 24h later
//     case 0:
//       return 24;
//     // 4 days later
//     case 1:
//       return 2 * 24;
//     case 2:
//       return 4 * 24;
//     // 1 week later
//     case 3:
//       return 7 * 24;
//     // 3 weeks later
//     case 4:
//       return 21 * 24;
//     // 2 months later
//     case 5:
//       return 60 * 24;
//     // 4 months later

//     default:
//       return 24;
//   }
// }
