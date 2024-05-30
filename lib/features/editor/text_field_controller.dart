import 'package:flutter/material.dart';

class TextFieldController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }
}
