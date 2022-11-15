import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/edit_subject/bloc/edit_subject_bloc.dart';
import 'package:learning_app/edit_subject/view/card_list_tile.dart';

class EditSubjectPage extends StatelessWidget {
  const EditSubjectPage({super.key, required this.subjectToEdit});

  /// when add_subject_page is used as edit_subject_page, when not let it empty
  final Subject subjectToEdit;

  @override
  Widget build(BuildContext context) {
    context
        .read<EditSubjectBloc>()
        .add(EditSubjectCardSubscriptionRequested(subjectToEdit.id));
    final nameController = TextEditingController(text: subjectToEdit.name);
    final locationController =
        TextEditingController(text: subjectToEdit.parentSubjectId);
    final iconController =
        TextEditingController(text: subjectToEdit.prefixIcon);
    print(subjectToEdit.id);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Subject')),
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
                  final nameInput = nameController.text.trim();
                  final locationInput = locationController.text.trim();
                  final iconInput = locationController.text.trim();

                  if (!nothingChanged(
                      nameInput, locationInput, iconInput, subjectToEdit)) {
                    context.read<EditSubjectBloc>().add(EditSubjectSaveSubject(
                        subjectToEdit.copyWith(
                            name: nameInput,
                            parentSubjectId: locationInput,
                            prefixIcon: iconInput)));
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/add_card', arguments: subjectToEdit.id);
              },
              child: const Text('Add card'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/add_subject', arguments: subjectToEdit.id);
              },
              child: const Text('Add Subtopic'),
            ),
            BlocBuilder<EditSubjectBloc, EditSubjectState>(
                builder: (context, state) {
              if (state is EditSubjectCardsFetchingSuccess) {
                final cardListTiles = List<CardListTile>.empty(growable: true);
                state.cards.forEach((element) {
                  cardListTiles.add(CardListTile(card: element));
                });
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: cardListTiles,
                );
              }
              return Text("error");
            })
          ],
        ),
      )),
    );
  }

  bool nothingChanged(
      String name, String location, String icon, Subject currentSubject) {
    if (name != currentSubject.name ||
        location != currentSubject.parentSubjectId ||
        icon != currentSubject.prefixIcon) {
      return false;
    }
    return true;
  }
}
