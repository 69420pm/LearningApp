import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/front_back_seperator_tile.dart';
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

  double getBottomLimit(
      double screenHeight, double currentOffset, bool startScroll) {
    var offset = _cardsToLearn
            .sublist(0, currentIndex + 1)
            .map((e) => e.cardHeight)
            .fold<double>(
              0,
              (previousValue, element) => previousValue + (element ?? 0),
            ) -
        screenHeight;
    if (_cardsToLearn[currentIndex].turnedOver &&
        currentOffset - offset == 0 &&
        startScroll) {
      print("moin");
      offset += screenHeight;
    }

    return offset;
  }

  void _updateCurrentIndex(int newIndex) {
    if (currentIndex != newIndex) {
      currentIndex = newIndex;
      emit(NewCardState());
    }
  }

  void stopScrolling() {
    emit(StopScrollingState());
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

  void learnAllCards() async {
    print("lololo1");
    _cardsToLearn = _cardsRepository
        .learnAllCards()
        .map((e) => RenderCard(card: e))
        .toList()
      ..sort(
        (a, b) => b.dateCreated.compareTo(a.dateCreated),
      );
    ;

    for (var i = 0; i < cardsToLearn.length; i++) {
      final tiles = await _cardsRepository.getCardContent(cardsToLearn[i].uid);
      var indexSpacer =
          tiles.indexWhere((element) => element is FrontBackSeparatorTile);
      if (indexSpacer == -1) {
        indexSpacer = tiles.length;
      }

      cardsToLearn[i].frontTiles = tiles.sublist(0, indexSpacer);
      cardsToLearn[i].backTiles = tiles.sublist(indexSpacer, tiles.length);
    }

    emit(FinishedLoadingCardsState());
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
