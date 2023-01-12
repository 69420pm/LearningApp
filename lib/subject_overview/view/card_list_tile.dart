// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:ui_components/ui_components.dart';

import 'package:learning_app/subject_overview/bloc/card_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/subject_overview_page.dart';

class CardListTile extends StatefulWidget {
  CardListTile({
    super.key,
    required this.card,
    required this.isCardSelected,
    required this.isInSelectMode,
  });
  final Card card;
  bool isCardSelected;
  bool isInSelectMode;

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
            context.read<SubjectOverviewSelectionBloc>().add(
                SubjectOverviewSelectionChange(
                    card: widget.card, addCard: widget.isCardSelected));
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
                      card: widget.card, addCard: widget.isCardSelected));
            });
          }
        },
        child: LongPressDraggable(
          data: widget.card,
          maxSimultaneousDrags: widget.isInSelectMode ? 0 : 1,
          onDragStarted: () {
            if (!widget.isInSelectMode || widget.isCardSelected == false) {
              setState(() {
                widget.isCardSelected = true;
              });
            }
          },
          feedback: Builder(
            builder: (context) {
              final renderBox =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;

              final size = renderBox?.size;
              return CardListTileView(
                globalKey: globalKey,
                isSelected: widget.isCardSelected,
                card: widget.card,
                height: size?.height,
                width: size?.width,
              );
            },
          ),
          childWhenDragging: Container(),
          child: CardListTileView(
            globalKey: globalKey,
            isSelected: widget.isCardSelected,
            card: widget.card,
          ),
        ),
      ),
    );
  }
}
