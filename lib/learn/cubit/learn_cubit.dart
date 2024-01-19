import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/widgets/editor_tiles/front_back_seperator_tile.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_text.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnCubitState> {
  LearnCubit(this._cardsRepository) : super(LoadingCardsState());

  List<RenderCard> _cardsToLearn = List.empty(growable: true);
  List<RenderCard> get cardsToLearn => _cardsToLearn;

  int currentIndex = 0;
  double screenHeight = 0;

  void setHeight(int index, double height) {
    if (height != _cardsToLearn[index].cardHeight) {
      _cardsToLearn[index].cardHeight = height;
      emit(UpdateHeightState(index: index));
    }
  }

  bool currentCardIsTurned() {
    return _cardsToLearn[currentIndex].turnedOver;
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
      offset += screenHeight;
    }

    return offset;
  }

  void updateCurrentIndex(int newIndex) {
    if (currentIndex != newIndex) {
      currentIndex = newIndex;
      emit(NewCardState());
    }
  }

  void stopScrolling() {
    emit(StopScrollingState());
  }

  double? getAmountScrolledAway(double offset, double screenHeight) {
    var a = (getOffsetByIndex(currentIndex + 1) - offset) / screenHeight;
    if (a > 1) a -= 1;
    print(a);
    return 0;
  }

  double getOffsetByIndex(int index) {
    if (index > 0 && index < _cardsToLearn.length) {
      return _cardsToLearn
          .sublist(0, index)
          .where((element) => element.cardHeight != null)
          .fold<double>(
            0,
            (previousValue, element) => previousValue + element.cardHeight!,
          );
    }
    return 0;
  }

  double? getOffsetToBiggestCard(double offset, double screenHeight) {
    var height = 0.0;
    for (var i = 0; i < _cardsToLearn.length; i++) {
      if (_cardsToLearn[i].cardHeight == null) {
        throw Exception("Height of $i Card not calculated. Try to restart");
      } else {
        height += _cardsToLearn[i].cardHeight!;
      }
      if (height >= offset) {
        final border = ((height - offset) / screenHeight).clamp(0, 1);

        if (border == 1) {
          updateCurrentIndex(i);
          return null;
        } else if (border < 0.5) {
          if (currentIndex == i && !_cardsToLearn[currentIndex].turnedOver) {
            return height - screenHeight;
          }
          updateCurrentIndex(i + 1);
          return height;
        } else {
          updateCurrentIndex(i);
          return height - screenHeight;
        }
      }
    }
    return null;
  }

  bool isScrollingInsideCurrentCard(double offset, double screenHeight) {
    var offsetToCurrentCard = getOffsetByIndex(currentIndex);
    var offsetToNextCard = getOffsetByIndex(currentIndex + 1);
    return offset > offsetToCurrentCard &&
        offset < offsetToNextCard - screenHeight;
  }

  void startAnimation() {
    emit(StartAnimationState());
  }

  void endAnimation() {
    emit(FinishedAnimationState());
  }

  final CardsRepository _cardsRepository;

  void turnOverCard() {
    _cardsToLearn[currentIndex].turnedOver = true;
    emit(CardTurnedState());
  }

  Future<List<RenderCard>> setToLearnCards(List<Card> cards) async {
    _cardsToLearn = cards
        .map(
          (e) => RenderCard(
            card: e,
            cardsRepository: _cardsRepository,
            onImagesLoaded: () => emit(NewCardState()),
          ),
        )
        .toList()
      ..sort(
        (a, b) => b.dateCreated.compareTo(a.dateCreated),
      );
    // _cardsToLearn = _cardsToLearn.sublist(0, 4);

    //TODO Only load CardContent to display
    for (var i = 0; i < cardsToLearn.length; i++) {
      cardsToLearn[i].editorTiles =
          await _cardsRepository.getCardContent(cardsToLearn[i].uid);
    }

    emit(FinishedLoadingCardsState());
    return _cardsToLearn;
  }

  void _checkIfAllCardsRated() {
    //check if all got rated
    if (_cardsToLearn
        .where((element) => !element.gotRatedInThisSession)
        .isEmpty) {
      //get all bad rated Cards
      final gotBadCards = _cardsToLearn
          .where((element) => element.gotRatedBad && !element.finishedToday);

      //all cards good
      if (gotBadCards.isEmpty) {
        emit(FinishedLearningState());
      }

      //some bad
      else {
        _cardsToLearn = gotBadCards.map(
          (e) {
            e
              ..turnedOver = false
              ..gotRatedInThisSession = false;
            return e;
          },
        ).toList();
        emit(NextLearningSessionState());
      }
    }
  }

  void rateCard(LearnFeedback feedbackCard) {
    //"finish a card" means, that this card doesn't get a new dateToReview;
    //We might add random "finished" cards to a daily session, if there are for
    //example only a few cards on that day.

    //iterations to finish card
    const rehearsalIterations = 5;

    //minimal time it takes to finish a card if always rated good
    const minimalAmountDaysToLearnCard = 14;

    //rehearsal Curve (lots in the beginning, fewer in the end)
    const rehearsalCurve = Curves.easeInExpo;

    // generate list of time spans between rehearsals
    final nextDateToReview = List.generate(
      rehearsalIterations,
      (index) {
        return (rehearsalCurve.transform(
                  rehearsalIterations / minimalAmountDaysToLearnCard,
                ) *
                minimalAmountDaysToLearnCard)
            .round()
            .days;
      },
    );

    if (!_cardsToLearn[currentIndex].gotRatedInThisSession) {
      if (feedbackCard == LearnFeedback.good) {
        //first try/tries wrong, but now right
        if (_cardsToLearn[currentIndex].gotRatedBad) {
          _cardsToLearn[currentIndex].dateToReview =
              _cardsToLearn[currentIndex].dateToReview.add(1.days);
          if (_cardsToLearn[currentIndex].recallScore > 0) {
            _cardsToLearn[currentIndex].recallScore--;
          }
        }

        //first try right
        else {
          _cardsToLearn[currentIndex].dateToReview = _cardsToLearn[currentIndex]
              .dateToReview
              .add(nextDateToReview[_cardsToLearn[currentIndex].recallScore]);
          _cardsToLearn[currentIndex].recallScore += 1;
        }
        _cardsToLearn[currentIndex].finishedToday = true;
        _cardsRepository.saveCard(_cardsToLearn[currentIndex], null, null);
      }

      //bad
      else {
        _cardsToLearn[currentIndex].gotRatedBad = true;
        _cardsToLearn.add(_cardsToLearn[currentIndex]..turnedOver = false);
      }
    }
    _cardsToLearn[currentIndex].gotRatedInThisSession = true;
    _checkIfAllCardsRated();
    emit(CardRatedState());
  }
}

enum LearnFeedback { good, bad }
