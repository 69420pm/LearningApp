import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
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
    final locationController =
        TextEditingController(text: subjectToEdit.parentSubjectId);
    final iconController =
        TextEditingController(text: subjectToEdit.prefixIcon);

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: UIAppBar(
        title: Text("Subject Overview"),
      ),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UISizeConstants.paddingEdge),
          child: Column(
            children: [
              SizedBox(height: UISizeConstants.defaultSize),

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
                onLoseFocus: (_) => save(formKey, nameController.text,
                    locationController.text, iconController.text, context),
              ),

              /// File Location
              UITextFormField(
                controller: locationController,
                label: "FileLocation string",
                valitation: (_) => null,
                onLoseFocus: (_) => save(formKey, nameController.text,
                    locationController.text, iconController.text, context),
              ),

              /// Prefix icon
              UITextFormField(
                controller: iconController,
                valitation: (_) => null,
                label: "Icon String",
                onLoseFocus: (_) => save(formKey, nameController.text,
                    locationController.text, iconController.text, context),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/add_card', arguments: subjectToEdit.id);
                    },
                    icon: const Icon(
                      Icons.file_copy,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => AddFolderBottomSheet()),
                    icon: const Icon(Icons.create_new_folder_rounded),
                  ),
                ],
              ),

              BlocBuilder<EditSubjectBloc, EditSubjectState>(
                  builder: (context, state) {
                if (state is EditSubjectCardsFetchingSuccess) {
                  return ListView.builder(
                    itemCount: state.cards.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        CardListTile(card: state.cards[index]),
                    shrinkWrap: true,
                  );
                }
                return Text("error");
              })
            ],
          ),
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

  void save(GlobalKey<FormState> formKey, String nameInput,
      String locationInput, String iconInput, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (!nothingChanged(nameInput.trim(), locationInput.trim(),
          iconInput.trim(), subjectToEdit)) {
        context.read<EditSubjectBloc>().add(EditSubjectSaveSubject(
            subjectToEdit.copyWith(
                name: nameInput,
                parentSubjectId: locationInput,
                prefixIcon: iconInput)));
      }
    }
  }
}
