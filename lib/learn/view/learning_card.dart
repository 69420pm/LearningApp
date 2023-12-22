import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class LearningCard extends StatelessWidget {
  LearningCard({
    super.key,
    required this.cardUID,
    required this.indexOfCardStack,
  });
  final String cardUID;
  final int indexOfCardStack;
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final heightOfCard = MediaQuery.of(context).size.height -
        (Scaffold.of(context).appBarMaxHeight ?? 0);

    final heightOfFrontEditorTiles = 220;
    bool isAtBottom = false;
    bool isAtTop = true;

    var disableScrolling = false;
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent) {
        isAtBottom = true;
      } else if (controller.offset <= controller.position.minScrollExtent) {
        isAtTop = true;
      } else {
        isAtBottom = false;
        isAtTop = false;
      }
    });
    final frontWidgets = Container(
      // color: Colors.blue,
      height: heightOfCard,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Animate(
              adapter: ScrollAdapter(
            controller,
            end: 300,
          )).custom(
            builder: (_, value, __) => Container(
                height: (value) *
                    (heightOfCard - heightOfFrontEditorTiles)
                        .clamp(0, double.infinity)),
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.red,
            child: Center(
              child: Text(
                indexOfCardStack.toString(),
                style: UIText.titleBig,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 100,
              color: Colors.red,
              child: Center(child: Text("Front of Card"))),
        ],
      ),
    );
    final backWidgets = Container(
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.blue,
            child: Center(
              child: Text(
                indexOfCardStack.toString(),
                style: UIText.titleBig,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 100,
              color: Colors.blue,
              child: Center(child: Text("Back of Card"))),
          ...List.generate(
              indexOfCardStack + 1,
              (index) => Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      height: 100,
                      color: Colors.blue,
                    ),
                  ))
        ],
      ),
    );
    return BlocBuilder<LearnCubit, LearnState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<LearnCubit>().turnOverCard(indexOfCardStack);
          },
          child: NotificationListener<UserScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.direction == ScrollDirection.forward &&
                  isAtTop &&
                  indexOfCardStack != 0) {
                context.read<LearnCubit>().scrollToPreviousCard();
              } else if (scrollNotification.direction ==
                      ScrollDirection.reverse &&
                  isAtBottom &&
                  indexOfCardStack !=
                      context.read<LearnCubit>().cardsToLearn.length - 1) {
                context.read<LearnCubit>().scrollToNextCard();
              }

              return false;
            },
            child: SingleChildScrollView(
              controller: controller,
              physics: state is ScrollToNextCardsState ||
                      state is ScrollToPreviousCardsState
                  ? NeverScrollableScrollPhysics()
                  : ClampingScrollPhysics(),
              child: Column(
                children: [
                  frontWidgets,
                  Divider(
                    thickness: 2,
                  ),
                  backWidgets
                      .animate(
                        adapter: ScrollAdapter(controller, end: 200),
                      )
                      .fadeIn(curve: Curves.easeOutQuad)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
