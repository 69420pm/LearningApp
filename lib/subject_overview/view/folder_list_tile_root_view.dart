// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';

import 'card_list_tile.dart';
import 'folder_list_tile.dart';

class FolderListTileRootView extends StatelessWidget {
  const FolderListTileRootView({
    Key? key,
    required this.childListTiles,
  }) : super(key: key);

  final Map<String, Widget> childListTiles;

  @override
  Widget build(BuildContext context) {
    var isMovingUp = false;
    var isMovingDown = false;

    final globalKey = GlobalKey();
    final scrollController = ScrollController();
    return Listener(
      onPointerMove: (event) {
        if (context.read<SubjectOverviewSelectionBloc>().isInDragging) {
          final render =
              globalKey.currentContext?.findRenderObject() as RenderBox?;
          final top = render?.localToGlobal(Offset.zero).dy ?? 0;
          final bottom = MediaQuery.of(context).size.height;

          final relPos = (event.localPosition.dy / (bottom - top)).clamp(0, 1);

          if (relPos < .2 && isMovingUp == false) {
            isMovingUp = true;
            isMovingDown = false;

            scrollController.animateTo(
              0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
            );
          } else if (relPos > .8 && isMovingDown == false) {
            isMovingDown = true;
            isMovingUp = false;
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
            );
          } else if (relPos > .2 && relPos < .8) {
            if (isMovingUp || isMovingDown) {
              scrollController.jumpTo(scrollController.offset);
            }
            isMovingDown = false;
            isMovingUp = false;
          }
        }
      },
      child: CustomScrollView(
        key: globalKey,
        controller: scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => childListTiles.values
                  .whereType<FolderListTile>()
                  .elementAt(index),
              childCount:
                  childListTiles.values.whereType<FolderListTile>().length,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => childListTiles.values
                  .whereType<CardListTile>()
                  .elementAt(index),
              childCount:
                  childListTiles.values.whereType<CardListTile>().length,
            ),
          ),
        ],
      ),
    );
  }
}
