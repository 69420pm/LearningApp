import 'package:flutter/material.dart' hide Card;
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
    var controller = ScrollController();

    controller.addListener(
      () {
        if (controller.offset == controller.position.maxScrollExtent) {
          context.read<LearnCubit>().turnOverCard(indexOfCardStack);
        }
      },
    );

    return GestureDetector(
      onHorizontalDragStart: (details) {
        controller.animateTo(controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad);
      },
      onTap: () {
        // context.read<LearnCubit>().turnOverCard(indexOfCardStack);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          // horizontal: UIConstants.itemPadding,
          vertical: UIConstants.itemPadding,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
              // borderRadius: const BorderRadius.all(
              //     Radius.circular(UIConstants.cornerRadius)),
              // border: Border.all(
              //   color: UIColors.textLight,
              //   width: UIConstants.borderWidth,
              // ),
              // color: UIColors.overlay,
              ),
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            slivers: [
              SliverAppBar(
                // title: Text('card name'),
                expandedHeight: 400,
                automaticallyImplyLeading: false,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.red,
                      child: Text(
                        "Dolor enim labore esse commodo sit ut dolore eiusmod quis ullamco enim adipisicing?",
                        style: UIText.titleBig,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding:
                    const EdgeInsets.only(top: UIConstants.itemPaddingLarge),
                child: Container(
                  height: 400,
                  child: Text(
                    "Qui adipisicing do ipsum ut nulla dolore quis velit reprehenderit ex adipisicing voluptate. Sit amet occaecat commodo eiusmod. Et dolor esse cillum laboris amet ex dolor. Aliquip culpa qui ut velit laboris ullamco elit incididunt nulla labore cillum exercitation labore qui. Labore consequat velit eu irure reprehenderit minim pariatur duis. Eu commodo in excepteur ad est et. Cupidatat sunt excepteur laboris Lorem pariatur est amet ullamco sit.",
                    style: UIText.titleSmall,
                  ),
                ).animate(adapter: ScrollAdapter(controller)).fadeIn(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
