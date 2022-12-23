import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/card_list_tile_bloc.dart';
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  CardListTile({super.key, required this.card, required this.cardsRepository});
  final GlobalKey globalKey = GlobalKey();
  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardListTileBloc(cardsRepository),
      child: BlocBuilder<CardListTileBloc, CardListTileState>(
        builder: (context, state) {
          return LongPressDraggable(
            data: card,
            onDragEnd: (details) => context.read<CardListTileBloc>().add(
                  CardListTileChangeSelection(isSelected: details.wasAccepted),
                ),
            feedback: Builder(
              builder: (context) {
                final renderBox =
                    globalKey.currentContext?.findRenderObject() as RenderBox?;

                final size = renderBox?.size;
                return CardListTileView(
                  globalKey: globalKey,
                  isSelected: true,
                  card: card,
                  height: size?.height,
                  width: size?.width,
                );
              },
            ),
            childWhenDragging: Container(),
            child: CardListTileView(
              globalKey: globalKey,
              isSelected: state is CardListTileSelected,
              card: card,
            ),
          );
        },
      ),
    );
  }
}

class CardListTileView extends StatelessWidget {
  const CardListTileView({
    super.key,
    required this.card,
    this.isDragged,
    this.height,
    this.width,
    required this.isSelected,
    required this.globalKey,
  });

  final GlobalKey globalKey;
  final Card card;
  final bool? isDragged;
  final bool isSelected;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
      child: Container(
        height: height,
        width: width,
        key: globalKey,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: UISizeConstants.borderWidth,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: UISizeConstants.defaultSize),
            child: Text(
              card.front,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
