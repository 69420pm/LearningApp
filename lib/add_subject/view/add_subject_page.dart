import 'package:cards_api/cards_api.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class AddSubjectPage extends StatelessWidget {
  const AddSubjectPage({super.key, this.recommendedSubjectParentId});

  final String? recommendedSubjectParentId;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    if (recommendedSubjectParentId != null) {
      locationController.text = recommendedSubjectParentId!;
    }

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: UIAppBar(title: Text('Add page')),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            /// Name
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),

            /// File Location can be empty
            TextFormField(
              controller: locationController,
            ),

            /// Prefix icon
            TextFormField(
              controller: iconController,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await context.read<AddSubjectCubit>().saveSubject(
                        nameController.text,
                        locationController.text,
                        iconController.text);
                  }
                  Navigator.pop(context);
                },
                child: Text("Save"))
          ],
        ),
      )),
    );
  }
}
