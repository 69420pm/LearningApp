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
  LearnCubit(this._cardsRepository) : super(LoadingCardsState());

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

  Future<void> loadTodaysCards() async {
    _cardsToLearn = _cardsRepository
        .getAllCardsToLearnForToday()
        .map((e) => RenderCard(card: e, cardsRepository: _cardsRepository))
        .toList()
      ..sort(
        (a, b) => b.dateCreated.compareTo(a.dateCreated),
      );
    _cardsToLearn = _cardsToLearn.sublist(0, 4);

    print(_cardsToLearn.length);

    //TODO Only load CardContent to display
    for (var i = 0; i < cardsToLearn.length; i++) {
      cardsToLearn[i].editorTiles =
          await _cardsRepository.getCardContent(cardsToLearn[i].uid);
    }

    emit(FinishedLoadingCardsState());
  }

  void rateCard(LearnFeedback feedbackCard) {
    const nextDateToReview = <Duration>[Duration(days: 1), Duration(days: 2)];

    if (feedbackCard == LearnFeedback.good) {
      if (_cardsToLearn[currentIndex].gotRatedBad) {
        _cardsToLearn[currentIndex].dateToReview.subtract(nextDateToReview[
            (_cardsToLearn[currentIndex].recallScore - 2)
                .clamp(0, nextDateToReview.length - 1)]);
        if (_cardsToLearn[currentIndex].recallScore > 0) {
          _cardsToLearn[currentIndex].recallScore--;
        }
      } else {
        _cardsToLearn[currentIndex].dateToReview.add(nextDateToReview[
            _cardsToLearn[currentIndex]
                .recallScore
                .clamp(0, nextDateToReview.length - 1)]);
        _cardsToLearn[currentIndex].recallScore += 1;
      }
      _cardsToLearn[currentIndex].finishedToday = true;
      _cardsRepository.saveCard(_cardsToLearn[currentIndex], null, null);
    }
    // MEDIUM
    else {
      _cardsToLearn[currentIndex].gotRatedBad = true;
      _cardsToLearn.add(_cardsToLearn[currentIndex]..turnedOver = false);
    }

    emit(CardRatedState());
  }
}

enum LearnFeedback { good, bad }
