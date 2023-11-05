import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';

class AutoScrollView extends StatelessWidget {
  const AutoScrollView(
      {super.key,
      required this.child,
      required this.globalKey,
      required this.scrollController});

  final Widget child;
  final GlobalKey globalKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var isMovingDown = false;
    var isMovingUp = false;

    double? startScrollOffset;
    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      buildWhen: (previous, current) {
        return current is SubjectOverviewSelectionModeOn ||
            current is SubjectOverviewSelectionModeOff;
      },
      builder: (context, state) {
        return Listener(
          onPointerUp: (event) {
            if (!context.read<SubjectOverviewSelectionBloc>().isInSelectMode &&
                startScrollOffset != null) {
              print(startScrollOffset);
              scrollController.jumpTo(startScrollOffset!);
            }
            startScrollOffset = null;
          },
          onPointerMove: (event) {
            if (context.read<SubjectOverviewSelectionBloc>().isInDragging) {
              final render =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;
              final top = render?.localToGlobal(Offset.zero).dy ?? 0;
              final bottom = MediaQuery.of(context).size.height;

              final relPos =
                  (event.localPosition.dy / (bottom - top)).clamp(0, 1);
              startScrollOffset ??= scrollController.offset;
              const space = 0.3;

              if (relPos < space && isMovingUp == false) {
                isMovingUp = true;
                isMovingDown = false;

                scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              } else if (relPos > 1 - space && isMovingDown == false) {
                isMovingDown = true;
                isMovingUp = false;
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
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
