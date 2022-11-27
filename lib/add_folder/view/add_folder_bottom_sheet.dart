import 'package:cards_api/cards_api.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/cubit/add_folder_cubit.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:ui_components/ui_components.dart';

class AddFolderBottomSheet extends StatelessWidget {
  const AddFolderBottomSheet(
      {super.key,
      this.recommendedSubjectParentId,
      this.parentSubject,
      this.parentFolder});

  final String? recommendedSubjectParentId;
  final Subject? parentSubject;
  final Folder? parentFolder;

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
              validation: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),

            UIButton(
                onTap: () async {
                  context.read<EditSubjectBloc>().add(EditSubjectAddFolder(name: nameController.text.trim(), parentFolder: parentFolder, parentSubject: parentSubject));
                  Navigator.pop(context);
                },
                lable: "Save")
          ],
        ),
      )),
    );
  }
}
