import 'dart:async';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';
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
  bool scrollToBottom = false;
  bool inScroll = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heights = [
      screenHeight,
      screenHeight * 1.2,
      screenHeight * 2,
      screenHeight * 4,
      screenHeight
    ];
    return Scaffold(
      backgroundColor: UIColors.background,
      // appBar: const UIAppBar(
      //   leadingBackButton: true,
      //   title: 'Learning Site',
      // ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // if (notification.direction == ScrollDirection.idle) {

          var scrollRatio =
              itemPositionsListener.itemPositions.value.first.itemTrailingEdge;

          if (scrollRatio > 0.5) {
            setState(() {
              currentIndex =
                  itemPositionsListener.itemPositions.value.first.index;
              scrollToBottom = true;
            });
          } else {
            setState(() {
              currentIndex =
                  itemPositionsListener.itemPositions.value.last.index;
            });
            scrollToBottom = false;
          }

          // if (scrollRatio != 1) {
          //   itemScrollController.jumpTo(index: currentIndex, alignment: -0.5);
          // }
          // }
          return true;
        },
        child: ScrollablePositionedList.builder(
          padding: EdgeInsets.all(10),
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: screenHeight * 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: index == currentIndex ? Colors.red : Colors.blue,
                ),
                child: Center(
                    child: Text(
                  index.toString(),
                  style: UIText.titleBig,
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
