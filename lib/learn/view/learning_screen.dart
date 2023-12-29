import 'dart:async';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create()..itemPositions;
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  int currentIndex = 0;
  bool inScroll = false;

  @override
  Widget build(BuildContext context) {
    final visibleCards = itemPositionsListener.itemPositions.value.toList();
    const minDrag = 0.1;

    //

    return Scaffold(
      backgroundColor: UIColors.background,
      appBar: const UIAppBar(
        leadingBackButton: true,
        title: 'Learning Site',
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            final scrollRatio = itemPositionsListener
                .itemPositions.value.first.itemTrailingEdge
                .clamp(0, 1);
            print(scrollRatio);
            if (scrollRatio > 1 - minDrag) {
              setState(() {
                currentIndex =
                    itemPositionsListener.itemPositions.value.first.index;
              });
            } else if (scrollRatio < minDrag) {
              setState(() {
                currentIndex =
                    itemPositionsListener.itemPositions.value.last.index;
              });
            } else {
              setState(() {
                currentIndex = itemPositionsListener.itemPositions.value
                    .elementAt(scrollRatio < .5 ? 0 : 1)
                    .index;
              });
            }

            if (scrollRatio != 1) {
              itemScrollController.scrollTo(
                  index: currentIndex,
                  duration: Duration(milliseconds: 400),
                  alignment: scrollRatio < .5 ? 0 : 0);
            }
          }
          return true;
        },
        child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Placeholder(
              fallbackHeight: MediaQuery.of(context).size.height * 1.5,
              color: index == currentIndex ? Colors.red : Colors.blue,
            );
          },
        ),
      ),
    );
  }
}
