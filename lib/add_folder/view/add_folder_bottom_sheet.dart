import 'package:cards_api/cards_api.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class AddFolderBottomSheet extends StatelessWidget {
  const AddFolderBottomSheet({super.key, this.recommendedSubjectParentId});

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
    return BottomSheet(
      ///* hier auch save oder cancle?
      onClosing: () {},
      builder: (context) => SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            /// Name
            UITextFormField(
              controller: nameController,
              valitation: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),

            UIButton(onTap: () {}, lable: "Save")
          ],
        ),
      )),
    );
  }
}
