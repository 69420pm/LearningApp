// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocConsumer<EditSubjectBloc, EditSubjectState>(
      listener: (context, state) {
        if (state is EditSubjectFoldersSelectModeOn) {
          widget.isInSelectMode = true;
        }
        if (state is EditSubjectFoldersSelectModeOff) {
          widget.isInSelectMode = false;
          setState(() {
            widget.isCardSelected = false;
          });
        }
      },
      builder: (context, state) => GestureDetector(
        onTap: () {
          print("shortpress");
          if (widget.isInSelectMode) {
            setState(() {
              widget.isCardSelected = true;
            });
          }
        },
        child: LongPressDraggable(
          data: widget.card,
          onDragStarted: () {
            print("longpress");
            if (!widget.isInSelectMode || widget.isCardSelected == false) {
              setState(() {
                widget.isCardSelected = true;
              });
            }
          },
          onDragEnd: (details) {
            if (!details.wasAccepted) {
              context
                  .read<EditSubjectBloc>()
                  .add(EditSubjectToggleSelectMode(inSelectMode: true));
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

class CardListTileView extends StatelessWidget {
  const CardListTileView({
    super.key,
    required this.card,
    this.isDragged = false,
    this.height,
    this.width,
    required this.isSelected,
    required this.globalKey,
  });

  final GlobalKey globalKey;
  final Card card;
  final bool isDragged;
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
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: UISizeConstants.defaultSize),
                child: Text(
                  card.front,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
