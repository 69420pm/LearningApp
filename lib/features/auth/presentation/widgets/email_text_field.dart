import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField(
      {super.key, required this.emailController, this.onSubmitted});

  final TextEditingController emailController;
  final Function? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return UITextFormField(
      autofillHints: const [AutofillHints.email],
      inputType: TextInputType.emailAddress,
      textInputAction:
          onSubmitted == null ? TextInputAction.next : TextInputAction.done,
      controller: emailController,
      validation: (text) {
        if (text!.isEmpty) {
          return "Email cannot be empty";
        }
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text)) {
          return "Invalid email";
        }
      },
      onFieldSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
      label: 'Email',
    );
  }
}
