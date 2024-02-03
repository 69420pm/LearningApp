import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';

class DragWrapper extends StatefulWidget {
  DragWrapper({super.key, required this.child, required this.index});
  EditorTile child;
  int index;

  @override
  State<DragWrapper> createState() => _DragWrapperState();
}

class _DragWrapperState extends State<DragWrapper> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: widget.index,
      // hitTestBehavior: HitTestBehavior.opaque,
      axis: Axis.vertical,
      feedback: IgnorePointer(child: widget.child as Widget),
      child: ColoredBox(
        color: Colors.transparent,
        child: Focus(
          child: Stack(
            children: [
              widget.child as Widget,
              Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                    visible: visible,
                    child: UIIconButton(
                      icon: UIIcons.dragIndicator
                          .copyWith(size: 28, color: UIColors.smallText),
                      onPressed: () {},
                    )),
              )
            ],
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus == true) {
              context.read<AddCardCubit>().focusEditorTile(widget.child);
            } else {
              if (FocusManager.instance.primaryFocus == null) {
                context.read<AddCardCubit>().focusEditorTile(null);
              }
            }
            setState(() {
              visible = hasFocus;
            });
          },
        ),
      ),
    );
  }
}
