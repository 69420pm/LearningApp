import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/render_card.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnCubitState> {
  LearnCubit(this._cardsRepository) : super(LoadingCardsState());
  final CardsRepository _cardsRepository;

  List<RenderCard> _cardsToLearn = List.empty(growable: true);
  List<RenderCard> get cardsToLearn => _cardsToLearn;

  int currentIndex = 0;
  double screenHeight = 0;

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

    currentIndex = 0;

    emit(FinishedLoadingCardsState());
    return _cardsToLearn;
  }

  void setHeight(int index, double height) {
    if (height != _cardsToLearn[index].cardHeight) {
      _cardsToLearn[index].cardHeight = height;
      emit(UpdateHeightState(index: index));
    }
  }

  bool currentCardIsTurned() {
    return _cardsToLearn[currentIndex].turnedOver;
  }

  void updateCurrentIndex(int newIndex) {
    if (currentIndex != newIndex) {
      currentIndex = newIndex;
      emit(NewCardState());
    }
  }

  void turnOverCurrentCard() {
    _cardsToLearn[currentIndex].turnedOver = true;
    emit(CardTurnedState());
  }

  void stopScrolling() {
    emit(StopScrollingState());
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

  double? getAmountScrolledAway(double offset, double screenHeight) {
    var a = (getOffsetByIndex(currentIndex + 1) - offset) / screenHeight;
    if (a > 1) a -= 1;
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
            updateCurrentIndex(i);
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

  void _checkIfAllCardsRated() {
    //check if all got rated
    if (_cardsToLearn.where((element) => element.feedback == null).isEmpty) {
      _updateAllCards();
    }
  }

  void _updateAllCards() {
    //"finish a card" means, that this card doesn't get a new dateToReview;
    //We might add random "finished" cards to a daily session, if there are for
    //example only a few cards on that day.

    // //iterations to finish card
    // const rehearsalIterations = 5;

    // //minimal time it takes to finish a card if always rated good
    // const minimalAmountDaysToLearnCard = 14;

    // //rehearsal Curve (lots in the beginning, fewer in the end)
    // const rehearsalCurve = Curves.easeInExpo;

    // // generate list of time spans between rehearsals
    // final nextDateToReview = List.generate(
    //   rehearsalIterations,
    //   (index) {
    //     return (rehearsalCurve.transform(
    //               rehearsalIterations / minimalAmountDaysToLearnCard,
    //             ) *
    //             minimalAmountDaysToLearnCard)
    //         .round()
    //         .days;
    //   },
    // );

    final nextDateToReview = [
      0.days,
      1.days,
      2.days,
      3.days,
      5.days,
      8.days,
      10.days,
      30.days,
    ];

    for (var i = 0; i < _cardsToLearn.length; i++) {
      switch (_cardsToLearn[i].feedback!) {
        case LearnFeedback.good:
          _cardsToLearn[i].recallScore += 1;
          if (_cardsToLearn[i].recallScore < nextDateToReview.length) {
            _cardsToLearn[i].dateToReview = DateUtils.dateOnly(DateTime.now())
                .add(nextDateToReview[_cardsToLearn[i].recallScore]);
          } else {
            // card is finished
            _cardsToLearn[i].dateToReview = null;
          }

        case LearnFeedback.medium:
          _cardsToLearn[i].recallScore += 0;
          _cardsToLearn[i].dateToReview =
              DateUtils.dateOnly(DateTime.now()).add(1.days);

        case LearnFeedback.bad:
          if (_cardsToLearn[i].recallScore > 0) {
            _cardsToLearn[i].recallScore -= 2;
            _cardsToLearn[i].dateToReview = DateUtils.dateOnly(DateTime.now());
          }
      }
      _cardsRepository.saveCard(_cardsToLearn[i], null, null);
    }

    emit(FinishedLearningState());
  }

  void rateCard(LearnFeedback feedbackCard, int index) {
    if (_cardsToLearn[index].feedback != feedbackCard) {
      _cardsToLearn[index].feedback = feedbackCard;
      emit(CardRatedState());
      _checkIfAllCardsRated();
    }
  }
}

enum LearnFeedback { good, medium, bad }
