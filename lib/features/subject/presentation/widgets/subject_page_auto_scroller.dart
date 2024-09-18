import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

class AutoScrollView extends StatelessWidget {
  const AutoScrollView({
    super.key,
    required this.child,
    required this.globalKey,
    required this.scrollController,
  });

  final Widget child;
  final GlobalKey globalKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var isMovingDown = false;
    var isMovingUp = false;

    double? startScrollOffset;
    return BlocBuilder<SubjectHoverCubit, SubjectHoverState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Listener(
          onPointerUp: (event) {
            if (!context.read<SubjectSelectionCubit>().inSelectionMode &&
                startScrollOffset != null) {
              scrollController.jumpTo(startScrollOffset!);
            }
            startScrollOffset = null;
          },
          onPointerMove: (event) {
            if (context.read<SubjectHoverCubit>().isDragging &&
                scrollController.position.maxScrollExtent != 0) {
              final render =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;
              final top = render?.localToGlobal(Offset.zero).dy ?? 0;
              final bottom = MediaQuery.of(context).size.height;

              final relPos =
                  (event.localPosition.dy / (bottom - top)).clamp(0, 1);
              startScrollOffset ??= scrollController.offset;
              const space = 0.1;
              const duration = Duration(milliseconds: 2500);
              const curve = Curves.easeIn;

              if (relPos < space && isMovingUp == false) {
                isMovingUp = true;
                isMovingDown = false;

                scrollController.animateTo(
                  0,
                  //makes it around the same speed , but a bit slower at the start of the list
                  duration: duration *
                      max(
                          0.4,
                          scrollController.position.pixels /
                              scrollController.position.maxScrollExtent),
                  curve: curve,
                );
              } else if (relPos > 1 - space && isMovingDown == false) {
                isMovingDown = true;
                isMovingUp = false;
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,

                  //makes it around the same speed , but a bit slower at the end of the list
                  duration: duration *
                      max(
                          0.4,
                          (scrollController.position.maxScrollExtent -
                                  scrollController.position.pixels) /
                              scrollController.position.maxScrollExtent),
                  curve: curve,
                );
              } else if (relPos > space && relPos < 1 - space) {
                if (isMovingUp || isMovingDown) {
                  scrollController.jumpTo(
                    scrollController.offset,
                  );
                }
                isMovingDown = false;
                isMovingUp = false;
              }
            }
          },
          child: child,
        );
      },
    );
  }
}
