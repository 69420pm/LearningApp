import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key, required this.cardsRepository});
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    context.read<LearnCubit>().learnAllCards();
    final cardsToLearn = context.read<LearnCubit>().cardsToLearn;

    return Scaffold(
      backgroundColor: UIColors.background,
      appBar: const UIAppBar(
        leadingBackButton: true,
        title: 'Learning Site',
      ),
      body: BlocBuilder<LearnCubit, LearnState>(
        builder: (context, state) {
          if (state is ScrollToNextCardsState ||
              state is ScrollToPreviousCardsState) {
            controller.animateToPage(
              controller.page!.round() +
                  (state is ScrollToNextCardsState ? 1 : -1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutQuad,
            );
          }
          return PageView.builder(
            onPageChanged: (_) => context.read<LearnCubit>().newCard(),
            physics: state is ScrollToNextCardsState
                ? BouncingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            controller: controller,
            scrollDirection: Axis.vertical,
            itemCount: cardsToLearn.length,
            itemBuilder: (context, index) => LearningCard(
              cardUID: cardsToLearn[index],
              indexOfCardStack: index,
              cardsRepository: cardsRepository,
            ),
          );
        },
      ),
    );
  }
}
