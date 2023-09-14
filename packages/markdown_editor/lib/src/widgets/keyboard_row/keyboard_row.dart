import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_both_rows_add_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_latex_row.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_lower_row_text_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_upper_row_extra_format.dart';
import 'package:ui_components/ui_components.dart';

class KeyboardRow extends StatefulWidget {
  KeyboardRow({super.key});
  bool isVisible = false;

  @override
  State<KeyboardRow> createState() => _KeyboardRowState();
}

class _KeyboardRowState extends State<KeyboardRow> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      // visible: widget.isVisible,
      maintainState: true,
      child: BlocBuilder<KeyboardRowCubit, KeyboardRowState>(
        builder: (context, state) {
          if (state is KeyboardRowText) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 8,
                ),
                KeyboardButton(
                  icon: UIIcons.add,
                  onPressed: () {
                    context.read<KeyboardRowCubit>().addNewTile();
                  },
                ),
                const Expanded(child: _EditTextRow()),
                KeyboardButton(icon: UIIcons.account, onPressed: () {}),
                const SizedBox(
                  width: 8,
                ),
              ],
            );
          } else if (state is KeyboardRowTextWithColors) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 8,
                ),
                KeyboardButton(
                  icon: UIIcons.add,
                  onPressed: () {
                    context.read<KeyboardRowCubit>().addNewTile();
                  },
                ),
                const Expanded(child: _EditTextRow()),
                KeyboardButton(icon: UIIcons.account, onPressed: () {}),
                const SizedBox(
                  width: 8,
                ),
              ],
            );
          } else if (state is KeyboardRowNewTile) {
            return const Column();
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      setState(() {
        widget.isVisible = true;
      });
    } else {
      setState(() {
        widget.isVisible = false;
      });
    }

    super.didChangeMetrics();
  }
}

class _EditTextRow extends StatefulWidget {
  const _EditTextRow({super.key});

  @override
  State<_EditTextRow> createState() => __EditTextRowState();
}

class __EditTextRowState extends State<_EditTextRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 4,
        ),
        KeyboardRowContainer(
          child: Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              KeyboardToggle(icon: UIIcons.formatBold, onPressed: (value) {}),
              KeyboardToggle(icon: UIIcons.formatItalic, onPressed: (value) {}),
              KeyboardToggle(
                icon: UIIcons.formatUnderline,
                onPressed: (value) {},
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          ),
        ),
        KeyboardRowContainer(
          child: Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              KeyboardToggle(
                icon: UIIcons.formatColorFill,
                onPressed: (value) {
                  context.read<KeyboardRowCubit>().expandColors();
                },
              ),
              KeyboardToggle(
                icon: UIIcons.formatColorText,
                onPressed: (value) {
                  context.read<KeyboardRowCubit>().expandColors();

                },
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
// import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_both_rows_add_tile.dart';
// import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_latex_row.dart';
// import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_lower_row_text_tile.dart';
// import 'package:markdown_editor/src/widgets/keyboard_row/rows/keyboard_upper_row_extra_format.dart';

// class KeyboardRow extends StatefulWidget {
//   KeyboardRow({super.key});

//   @override
//   State<KeyboardRow> createState() => _KeyboardRowState();
// }

// class _KeyboardRowState extends State<KeyboardRow> with WidgetsBindingObserver {
//   final List<bool> _selections = List.generate(7, (index) => false);

//   bool isVisible = false;
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<KeyboardRowCubit, KeyboardRowState>(
//       builder: (context, state) {
//         return Visibility(
//           visible: isVisible,
//           maintainState: true,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surfaceVariant,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Column(
//               children: [
//                 if (state is KeyboardRowExtraFormat)
//                   KeyboardUpperRowExtraFormat(),
//                 if (state is KeyboardRowNewTextTile)
//                   const KeyboardBothRowsAddTile(),
//                 if (state is! KeyboardRowNewTextTile)
//                   KeyboardLowerRowTextTile(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeMetrics() {
//     if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
//       print("open");
//       setState(() {
//         isVisible = true;
//       });
//     } else {
//       print("close");
//       setState(() {
//         isVisible = false;
//       });
//     }

//     super.didChangeMetrics();
//   }
// }
