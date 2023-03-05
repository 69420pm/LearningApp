// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/inactive_folder_list_tile.dart';
import 'package:learning_app/subject_overview/view/multi_drag_indicator.dart';

class CardListTile extends StatefulWidget {
  CardListTile({
    super.key,
    required this.card,
    required this.isCardSelected,
    required this.isInSelectMode,
    this.isHighlight = false,
  });
  final Card card;
  bool isCardSelected;
  bool isInSelectMode;
  bool isHighlight;

  @override
  State<CardListTile> createState() => _CardListTileState();
}

class _CardListTileState extends State<CardListTile> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      listener: (context, state) {
        if (state is SubjectOverviewSelectionModeOn) {
          widget.isInSelectMode = true;
        }
        if (state is SubjectOverviewSelectionModeOff) {
          widget.isInSelectMode = false;
          setState(() {
            widget.isCardSelected = false;
          });
        }
      },
      builder: (context, state) => GestureDetector(
        onTap: () {
          if (widget.isInSelectMode) {
            setState(() {
              widget.isCardSelected = !widget.isCardSelected;
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewSelectionChange(
                      card: widget.card,
                      addCard: widget.isCardSelected,
                    ),
                  );
            });
          }
        },
        child: LongPressDraggable(
          data: widget.card,
          maxSimultaneousDrags:
              context.read<SubjectOverviewSelectionBloc>().isInSelectMode &&
                      !widget.isCardSelected
                  ? 0
                  : 1,
          onDragStarted: () {
            context
                .read<SubjectOverviewSelectionBloc>()
                .add(SubjectOverviewDraggingChange(inDragg: true));
            if (!widget.isInSelectMode || widget.isCardSelected == false) {
              setState(() {
                widget.isCardSelected = true;
              });
            }
          },
          onDragEnd: (details) => context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewDraggingChange(inDragg: false)),
          onDraggableCanceled: (_, __) {
            if (!widget.isCardSelected) {
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewSelectionToggleSelectMode(
                        inSelectMode: true),
                  );
              context.read<SubjectOverviewSelectionBloc>().add(
                    SubjectOverviewSelectionChange(
                      card: widget.card,
                      addCard: true,
                    ),
                  );
            }
          },
          feedback: Builder(
            builder: (_) {
              final renderBox =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;

              final size = renderBox?.size;

              return CardListTileMultiDragIndicator(
                cardAmount: context
                    .read<SubjectOverviewSelectionBloc>()
                    .cardsSelected
                    .length
                    .clamp(1, 10),
                firstCard: widget.card,
                height: size!.height,
                width: size.width,
              );
            },
          ),
          childWhenDragging: const PlaceholderWhileDragging(),
          child: CardListTileView(
            globalKey: globalKey,
            isSelected: widget.isCardSelected &&
                state is! SubjectOverviewSelectionMultiDragging,
            card: widget.card,
            isChildWhenDragging:
                state is SubjectOverviewSelectionMultiDragging &&
                    widget.isCardSelected,
            isHighlight: widget.isHighlight,
          ),
        ),
      ),
    );
  }
}
