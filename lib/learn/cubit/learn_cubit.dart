import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_text.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnCubitState> {
  LearnCubit(this._cardsRepository) : super(NewCardState());

  List<RenderCard> _cardsToLearn = List.empty(growable: true);
  List<RenderCard> get cardsToLearn => _cardsToLearn;

  int currentIndex = 0;
  double screenHeight = 0;

  void setHeight(int index, double height) {
    if (height != _cardsToLearn[index].cardHeight) {
      _cardsToLearn[index].cardHeight = height;
      emit(UpdateHeightState());
    }
  }

  double getOffsetOfCardByIndex(int index) {
    final offset =
        _cardsToLearn.sublist(0, index).map((e) => e.cardHeight).fold<double>(
              0,
              (previousValue, element) => previousValue + (element ?? 0),
            );
    return offset;
  }

  void _updateCurrentIndex(int newIndex) {
    if (currentIndex != newIndex) {
      currentIndex = newIndex;
      emit(NewCardState());
    }
  }

  double? getOffsetToAnimate(double offset, double screenHeight) {
    double height = 0;
    for (var i = 0; i < _cardsToLearn.length; i++) {
      if (_cardsToLearn[i].cardHeight == null) {
        throw Exception("Height of $i Card not calculated. Try to restart");
      } else {
        height += _cardsToLearn[i].cardHeight!;
      }
      if (height >= offset) {
        final border = ((height - offset) / screenHeight).clamp(0, 1);

        if (border == 1) {
          _updateCurrentIndex(i);
          return null;
        } else if (border < 0.5) {
          _updateCurrentIndex(i + 1);

          return height;
        } else {
          _updateCurrentIndex(i);
          return height - screenHeight;
        }
      }
    }
    return null;
  }

  void startAnimation() {
    emit(StartAnimationState());
  }

  void endAnimation() {
    emit(FinishedAnimationState());
  }

  final CardsRepository _cardsRepository;

  void turnOverCard(int index) {
    if (index == currentIndex) {
      _cardsToLearn[index].turnedOver = true;
      emit(CardTurnedState());
    }
  }

  void learnAllCards() {
    _cardsToLearn = _cardsRepository
        .learnAllCards()
        .map(
          (e) => RenderCard(
            card: e,
            frontTiles: List.generate(
              Random().nextInt(4) + 1,
              (index) => Placeholder(
                fallbackHeight: 10 + 500 * Random().nextDouble(),
                color: Colors.red,
                child: Center(
                  child: Text(
                    "Editor Tile on Front",
                    style: UIText.titleBig,
                  ),
                ),
              ),
            ),
            backTiles: List.generate(
              Random().nextInt(4) + 1,
              (index) => Placeholder(
                color: Colors.blue,
                fallbackHeight: 10 + 500 * Random().nextDouble(),
                child: Center(
                  child: Text(
                    "Editor Tile on Back",
                    style: UIText.titleBig,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList()
      ..sort(
        (a, b) => b.dateCreated.compareTo(a.dateCreated),
      );

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
