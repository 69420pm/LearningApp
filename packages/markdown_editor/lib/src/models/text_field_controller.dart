import "package:flutter/material.dart";

class TextFieldController extends TextEditingController{

@override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];
 
    
    return TextSpan(style: style, children: children);
  }

}
