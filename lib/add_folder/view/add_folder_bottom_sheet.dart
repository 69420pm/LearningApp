import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/edit_subject_bloc/subject_overview_bloc.dart';
import 'package:ui_components/ui_components.dart';

class AddFolderBottomSheet extends StatelessWidget {
  const AddFolderBottomSheet({
    super.key,
    required this.parentId,
    this.parentSubject,
    this.parentFolder,
  });

  final String parentId;
  final Subject? parentSubject;
  final Folder? parentFolder;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    locationController.text = parentId;

    final formKey = GlobalKey<FormState>();
    return UIBottomSheet(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultSize,
          ),
          child: UITextFormField(
            controller: nameController,
            autofocus: true,
            label: 'Add Folder',
            onFieldSubmitted: (_) {
              context.read<EditSubjectBloc>().add(
                    EditSubjectAddFolder(
                      name: nameController.text.trim(),
                      parentId: parentId,
                    ),
                  );
              Navigator.pop(context);
            },
            validation: (value) {
              if (value!.isEmpty) {
                return 'Enter something';
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
