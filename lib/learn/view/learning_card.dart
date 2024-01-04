import 'package:flutter/material.dart' hide Card;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class LearningCard extends StatelessWidget {
  const LearningCard(
      {super.key, required this.card, required this.isCurrentIndex});

  final RenderCard card;
  final bool isCurrentIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: UIColors.overlay,
              borderRadius:
                  BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
            ),
            child: Column(
              children: [
                ...card.frontWidgets,
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: UIColors.overlay,
              borderRadius:
                  BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
            ),
            child: Column(
              children: [
                ...card.backWidgets,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
