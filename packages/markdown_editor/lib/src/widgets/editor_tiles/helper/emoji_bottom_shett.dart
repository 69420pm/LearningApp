import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/src/widgets/bottom_sheet.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ui_components/src/widgets/emoji_picker.dart';

class EmojiBottomSheet extends StatelessWidget {
  const EmojiBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return UIBottomSheet(child: UIEmojiPicker());
  }
}
