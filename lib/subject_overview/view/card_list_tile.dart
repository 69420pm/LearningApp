import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/card_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/view/card_draggable_tile.dart';
import 'package:ui_components/ui_components.dart';

class CardListTile extends StatelessWidget {
  const CardListTile(
      {super.key, required this.card, required this.cardsRepository});

  final Card card;
  final CardsRepository cardsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardListTileBloc(cardsRepository),
      child: CardListTileView(
        card: card,
        cardsRepository: cardsRepository,
      ),
    );
  }
}

class CardListTileView extends StatefulWidget {
  CardListTileView(
      {super.key, required this.card, required this.cardsRepository});

  final Card card;
  final CardsRepository cardsRepository;

  @override
  State<CardListTileView> createState() => _CardListTileViewState();
}

class _CardListTileViewState extends State<CardListTileView> {
  bool isDragged = false;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
      child: Container(
        key: globalKey,
        width: double.infinity,
        height: UISizeConstants.defaultSize * 5,
        decoration: BoxDecoration(
          color: isDragged
              ? Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.4)
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(UISizeConstants.cornerRadius),
          ),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.card.front,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  /// delete card
                  context.read<CardListTileBloc>().add(
                        CardListTileDeleteCard(
                          id: widget.card.id,
                          parentId: widget.card.parentId,
                        ),
                      );
                },
                icon: const Icon(Icons.delete),
              ),
              Draggable(
                  data: widget.card,
                  feedback: CardDraggableListTile(
                    card: widget.card,
                  ),
                  onDragStarted: () => setState(
                        () => isDragged = true,
                      ),
                  onDragEnd: (_) => setState(
                        () => isDragged = false,
                      ),
                  child: Icon(Icons.drag_indicator_sharp)),
            ],
          ),
        ),
      ),
    );
  }
}
