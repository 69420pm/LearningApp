import 'package:flutter/material.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class UITextField extends StatelessWidget {
  UITextField({
    super.key,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.hintText,
    this.initialValue,
    this.style,
    this.multiline = 1,
    this.keyboardType,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Manages focus of textfield
  final FocusNode? focusNode;

  /// text style of textfield
  final TextStyle? style;

  /// Whether the textfield should get focused on rebuild
  bool autofocus;

  String? hintText;
  String? initialValue;

  String? Function(String?)? validator;

  void Function(String)? onFieldSubmitted;

  void Function(String)? onChanged;
  int? multiline;

  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      autofocus: autofocus,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: TextInputAction.next,
      cursorColor: UIColors.smallText,
      onChanged: onChanged,
      maxLines: multiline,
      style: style ?? UIText.label,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: hintText,
      ),
    );
  }
}
