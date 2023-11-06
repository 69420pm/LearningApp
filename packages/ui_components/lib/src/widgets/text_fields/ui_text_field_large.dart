import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UITextFieldLarge extends StatelessWidget {
  UITextFieldLarge(
      {super.key,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.validator,
      this.onFieldSubmitted,
      this.onChanged,});

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Manages focus of textfield
  final FocusNode? focusNode;

  /// Whether the textfield should get focused on rebuild
  bool autofocus;

  String? Function(String?)? validator;

  void Function(String?)? onFieldSubmitted;

  void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: TextInputAction.next,
      cursorColor: UIColors.smallText,
      onChanged: onChanged,
      style: UIText.titleBig,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: 'Name',
      ),
    );
  }
}
