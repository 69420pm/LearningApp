import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_components/src/ui_size_constants.dart';

class UITextFormField extends StatefulWidget {

  const UITextFormField({
    super.key,
    this.label,
    required this.controller,
    this.inputType,
    this.maxLength,
    this.formater,
    this.initialValue,
    required this.validation,
    this.onChanged,
    this.autofocus,
    this.onFieldSubmitted,
    this.hintText,
    this.suffixIcon,
    this.icon,
    this.textInputAction,
    this.onLoseFocus,
  });
  final String? label, hintText;
  final Widget? suffixIcon;
  final Widget? icon;
  final TextEditingController controller;
  final int? maxLength;
  final String? initialValue;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formater;
  final String? Function(String?) validation;
  final Function(String)? onChanged, onFieldSubmitted, onLoseFocus;
  final bool? autofocus;
  final TextInputAction? textInputAction;

  @override
  State<UITextFormField> createState() => _UITextFormFieldState();
}

class _UITextFormFieldState extends State<UITextFormField> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
      if (widget.onLoseFocus != null && !focusNode.hasFocus) {
        widget.onLoseFocus!(widget.controller.text);
      }
    });
    widget.controller.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///* Label über textfield deprecated
          // if (widget.label != null)
          //   Padding(
          //     padding: const EdgeInsets.only(
          //         left: 12, bottom: UiSizeConstants.defaultSize),
          //     child: Text(
          //       widget.label ?? "",
          //       style: Theme.of(context).textTheme.labelSmall?.copyWith(
          //           color: Theme.of(context).colorScheme.onSurfaceVariant),
          //     ),
          //   ),
          Padding(
            padding: const EdgeInsets.only(bottom: UISizeConstants.defaultSize),
            child: TextFormField(
              textInputAction: widget.textInputAction,
              autofocus: widget.autofocus ?? false,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validation,
              keyboardType: widget.inputType,
              inputFormatters: widget.formater,
              controller: widget.controller,
              maxLength: widget.maxLength != 0 ? widget.maxLength : null,
              focusNode: focusNode,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                label: Text(widget.label ?? ''),
                suffixIcon: widget.suffixIcon,
                icon: widget.icon,
                hintText: widget.hintText,
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline, width: 2,),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error, width: 2,),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius),
                  borderSide: const BorderSide(width: 2),
                ),

                errorStyle:
                    TextStyle(color: Theme.of(context).colorScheme.error),
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                // fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
