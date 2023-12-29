import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/models/read_only_interactable.dart';
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
    required this.cardsRepository,
  });
  final String cardUID;
  final int indexOfCardStack;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    bool isAtBottom = false;
    bool isAtTop = true;

    final controller = ScrollController();
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
    final heightOfCard = MediaQuery.of(context).size.height -
        (Scaffold.of(context).appBarMaxHeight ?? 0);
    final heightOfFrontEditorTiles = 220;
    final frontWidgets = cardsRepository.getCardContent(cardUID);

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
              child: FutureBuilder(
                future: frontWidgets,
                initialData: [],
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      ...snapshot.data!.map(
                        (e) {
                          if (e is ReadOnlyInteractable) {
                            (e as ReadOnlyInteractable)..interactable = false;
                            return e as Widget;
                          } else {
                            // bloc touch input, when not audio tile
                            return Placeholder(
                              fallbackHeight: 200,
                            );
                          }
                        },
                      ).toList(),
                      Divider(
                        thickness: 2,
                      ),
                      backWidgets
                          .animate(
                            adapter: ScrollAdapter(controller, end: 200),
                          )
                          .fadeIn(curve: Curves.easeOutQuad)
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
