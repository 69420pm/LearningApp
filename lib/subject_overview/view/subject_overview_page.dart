import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class SubjectOverviewPage extends StatelessWidget {
  const SubjectOverviewPage({super.key, required this.subjectToEdit});

  /// when add_subject_page is used as edit_subject_page, when not let it empty
  final Subject subjectToEdit;

  @override
  Widget build(BuildContext context) {
    context
        .read<EditSubjectBloc>()
        .add(EditSubjectCardSubscriptionRequested(subjectToEdit.id));
    final nameController = TextEditingController(text: subjectToEdit.name);
    // final locationController =
    //     TextEditingController(text: subjectToEdit.parentId);
    final iconController =
        TextEditingController(text: subjectToEdit.prefixIcon);

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: UIAppBar(
        title: Text("Edit Subject"),
      ),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: UiSizeConstants.defaultSize),

            /// Name
            UITextFormField(
              label: "Name",
              controller: nameController,
              initialValue: subjectToEdit.name,
              valitation: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),

            // /// File Location
            // UITextFormField(
            //   controller: locationController,
            //   label: "FileLocation string",
            //   valitation: (_) => null,
            // ),

            /// Prefix icon
            UITextFormField(
              controller: iconController,
              valitation: (_) => null,
              label: "Icon String",
            ),

            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final nameInput = nameController.text.trim();
                  final iconInput = iconController.text.trim();

                  if (!nothingChanged(
                      nameInput, iconInput, subjectToEdit)) {
                    context.read<EditSubjectBloc>().add(EditSubjectSaveSubject(
                        subjectToEdit.copyWith(
                            name: nameInput,
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
                    .pushNamed('/add_card', arguments: subjectToEdit);
              },
              child: const Text('Add card'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/add_subject', arguments: subjectToEdit.id);
              },
              child: const Text('Add Folder'),
            ),
            BlocBuilder<EditSubjectBloc, EditSubjectState>(
                builder: (context, state) {
              if (state is EditSubjectCardFetchingSuccess) {
                final cardListTiles = List<CardListTile>.empty(growable: true);
                subjectToEdit.childCards.forEach((element) {
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
      String name, String icon, Subject currentSubject) {
    if (name != currentSubject.name ||
        // location != currentSubject.parentId ||
        icon != currentSubject.prefixIcon) {
      return false;
    }
    return true;
  }
}
