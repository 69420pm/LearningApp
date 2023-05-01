// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class AddSubjectBottomSheet extends StatelessWidget {
  AddSubjectBottomSheet({
    super.key,
    this.recommendedSubjectParentId,
  });

  final String? recommendedSubjectParentId;
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final iconController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (recommendedSubjectParentId != null) {
      locationController.text = recommendedSubjectParentId!;
    }
    return UIBottomSheet(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultSize,
            ),
            child: UITextFormField(
              autofocus: true,
              controller: nameController,
              onFieldSubmitted: (_) async {
                if (formKey.currentState!.validate()) {
                  await context.read<AddSubjectCubit>().saveSubject(
                        nameController.text,
                        locationController.text,
                        iconController.text,
                      );
                }
                Navigator.pop(context);
              },
              validation: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
              label: 'Subject name',
            ),
          ),
        ),
      ),
    );
  }
}
