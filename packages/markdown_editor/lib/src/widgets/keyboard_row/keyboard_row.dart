import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/src/cubit/keyboard_row_cubit.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/keyboard_text_color_row.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/new_rows/keyboard_text_row.dart';
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
            return KeyboardTextRow();
          } else if (state is KeyboardRowTextWithColors) {
            return KeyboardTextColorRow();
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
