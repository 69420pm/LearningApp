import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/subject_overview/bloc/edit_subject_bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class SubjectOverviewPage extends StatefulWidget {
  const SubjectOverviewPage({
    super.key,
    required this.subjectToEdit,
    required this.editSubjectBloc,
  });

  final Subject subjectToEdit;
  final EditSubjectBloc editSubjectBloc;

  @override
  State<SubjectOverviewPage> createState() => _SubjectOverviewPageState();
}

class _SubjectOverviewPageState extends State<SubjectOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final _rootFolder = Folder(
      id: widget.subjectToEdit.id,
      dateCreated: "",
      name: "root",
      parentId: widget.subjectToEdit.id,
    );
    final nameController =
        TextEditingController(text: widget.subjectToEdit.name);
    final iconController =
        TextEditingController(text: widget.subjectToEdit.prefixIcon);
    final formKey = GlobalKey<FormState>();

    var childListTiles = <String, Widget>{};

    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: (state is SubjectOverviewSelectionModeOn)
                ? IconButton(
                    onPressed: () {
                      context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionToggleSelectMode(
                              inSelectMode: false,
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.cancel,
                    ),
                  )
                : null,
            title: Text(widget.subjectToEdit.name),
            actions: (state is SubjectOverviewSelectionModeOn)
                ? [
                    IconButton(
                      onPressed: () {
                        context.read<SubjectOverviewSelectionBloc>().add(
                              SubjectOverviewSelectionDeleteSelectedCards(),
                            );
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/add_card',
                          arguments: widget.subjectToEdit.id,
                        );
                      },
                      icon: const Icon(
                        Icons.file_copy,
                      ),
                    ),
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<EditSubjectBloc>(),
                          child: AddFolderBottomSheet(
                            parentId: widget.subjectToEdit.id,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.create_new_folder_rounded),
                    ),
                  ],
          ),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UISizeConstants.paddingEdge,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: UISizeConstants.defaultSize),

                    /// Name
                    UITextFormField(
                      label: 'Name',
                      controller: nameController,
                      initialValue: widget.subjectToEdit.name,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Enter something';
                        } else {
                          return null;
                        }
                      },
                      onLoseFocus: (_) => save(
                        formKey,
                        nameController.text,
                        iconController.text,
                        context,
                      ),
                    ),

                    // /// Prefix icon
                    // UITextFormField(
                    //   controller: iconController,
                    //   initialValue: widget.subjectToEdit.prefixIcon,
                    //   validation: (_) => null,
                    //   label: 'Icon String',
                    //   onLoseFocus: (_) => save(
                    //     formKey,
                    //     nameController.text,
                    //     iconController.text,
                    //     context,
                    //   ),
                    // ),

                    Expanded(
                      child: FolderListTile(
                        cardsRepository: widget.editSubjectBloc.cardsRepository,
                        folder: _rootFolder,
                        isRoot: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool nothingChanged(String name, String icon, Subject currentSubject) {
    if (name != currentSubject.name ||
        // location != currentSubject.parentId ||
        icon != currentSubject.prefixIcon) {
      return false;
    }
    return true;
  }

  Future<void> save(
    GlobalKey<FormState> formKey,
    String nameInput,
    String iconInput,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      if (!nothingChanged(
        nameInput.trim(),
        iconInput.trim(),
        widget.subjectToEdit,
      )) {
        context.read<EditSubjectBloc>().add(
              EditSubjectSaveSubject(
                widget.subjectToEdit
                    .copyWith(name: nameInput, prefixIcon: iconInput),
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    widget.editSubjectBloc
        .add(EditSubjectCloseStreamById(id: widget.subjectToEdit.id));
    super.dispose();
  }
}
