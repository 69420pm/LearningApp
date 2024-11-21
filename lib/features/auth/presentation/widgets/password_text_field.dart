import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/text_form_field.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
    this.onSubmitted,
    this.passwordConfirm,
  });

  final TextEditingController passwordController;
  final Function? onSubmitted;
  final String? passwordConfirm;

  @override
  Widget build(BuildContext context) {
    return UITextFormField(
      autofillHints: const [AutofillHints.password],
      inputType: TextInputType.visiblePassword,
      textInputAction:
          onSubmitted != null ? TextInputAction.go : TextInputAction.next,
      controller: passwordController,
      obscureText: true,
      validation: (text) {
        if (passwordConfirm != null && text != passwordConfirm) {
          //TODO fix this
          //return "Passwords do not match";
        } else {
          if (text!.isEmpty) {
            return "Password cannot be empty";
          }
        }
      },
      label: 'Password',
      onFieldSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
    );
  }
}
