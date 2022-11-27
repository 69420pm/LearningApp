import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key, this.recommendedSubjectParent = null, this.folderParent = null});

  /// when add_Card_page is used as edit_Card_page, when not let it empty
  final Subject? recommendedSubjectParent;
  final Folder? folderParent;

  @override
  Widget build(BuildContext context) {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    if (recommendedSubjectParent != null) {
      locationController.text = recommendedSubjectParent!.id;
    }else if(folderParent != null){
      locationController.text = folderParent!.id;
    }

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: UIAppBar(title: Text("Add Card Page")),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            /// Name
            TextFormField(
              controller: frontController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: backController,
            ),

            /// File Location
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
                    // await context.read<AddCardCubit>().saveCard(
                    //     frontController.text,
                    //     backController.text,
                    //     recommendedSubjectParent!,
                    //     iconController.text);
                    context.read<EditSubjectBloc>().add(EditSubjectAddCard(front: frontController.text, back: backController.text, parentSubject: recommendedSubjectParent, parentFolder: folderParent));
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
