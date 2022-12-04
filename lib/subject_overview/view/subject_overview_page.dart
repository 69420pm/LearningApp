import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class SubjectOverviewPage extends StatefulWidget {
  SubjectOverviewPage({super.key, required this.subjectToEdit});

  /// when add_subject_page is used as edit_subject_page, when not let it empty
  final Subject subjectToEdit;
  Map<String, Widget> childListTiles = Map.identity();

  @override
  State<SubjectOverviewPage> createState() => _SubjectOverviewPageState();
}

class _SubjectOverviewPageState extends State<SubjectOverviewPage> {
  late final EditSubjectBloc _editSubjectBloc;
  @override
  Widget build(BuildContext context) {
    // context.read<EditSubjectBloc>().add(EditSubjectUpdateFoldersCards());
    final nameController =
        TextEditingController(text: widget.subjectToEdit.name);
    final iconController =
        TextEditingController(text: widget.subjectToEdit.prefixIcon);
    final formKey = GlobalKey<FormState>();
    context
        .read<EditSubjectBloc>()
        .add(EditSubjectGetChildrenById(id: widget.subjectToEdit.id));
    _editSubjectBloc = context.read<EditSubjectBloc>();
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
                initialValue: widget.subjectToEdit.name,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Enter something';
                  } else {
                    return null;
                  }
                },
                onLoseFocus: (_) => save(
                    formKey, nameController.text, iconController.text, context),
              ),

              /// Prefix icon
              UITextFormField(
                controller: iconController,
                initialValue: widget.subjectToEdit.prefixIcon,
                validation: (_) => null,
                label: "Icon String",
                onLoseFocus: (_) => save(
                    formKey, nameController.text, iconController.text, context),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_card',
                          arguments: widget.subjectToEdit.id);
                    },
                    icon: const Icon(
                      Icons.file_copy,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => BlocProvider.value(
                              value: context.read<EditSubjectBloc>(),
                              child: AddFolderBottomSheet(
                                  parentId: widget.subjectToEdit.id),
                            )),
                    icon: const Icon(Icons.create_new_folder_rounded),
                  ),
                ],
              ),

              BlocBuilder<EditSubjectBloc, EditSubjectState>(
                builder: (context, state) {
                  if (state is EditSubjectRetrieveChildren) {
                    // widget.childListTiles.addAll(state.childrenStream);
                    widget.childListTiles = {...widget.childListTiles, ...state.childrenStream}; 
                    print(widget.childListTiles);
                  }
                  List<Widget> _childTiles = [];
                  widget.childListTiles
                      .forEach((key, value) => _childTiles.add(value));
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _childTiles.length,
                    itemBuilder: (context, index) {
                      return _childTiles[index];
                    },
                  );
                },
              ),

              // BlocBuilder<EditSubjectBloc, EditSubjectState>(
              //     buildWhen: (previous, current) {
              //   if (current is EditSubjectFoldersCardsFetchingSuccess) {
              //     return true;
              //   }
              //   return false;
              // }, builder: (context, state) {
              //   if (state is EditSubjectFoldersCardsFetchingSuccess) {
              //     final cardListTiles =
              //         List<CardListTile>.empty(growable: true);
              //     final folderListTiles =
              //         List<FolderListTile>.empty(growable: true);
              //     subjectToEdit.childCards.forEach((element) {
              //       cardListTiles.add(CardListTile(card: element));
              //     });
              //     subjectToEdit.childFolders.forEach((element) =>
              //         folderListTiles.add(FolderListTile(folder: element)));
              //     return Column(
              //       children: [
              //         ListView(
              //           scrollDirection: Axis.vertical,
              //           shrinkWrap: true,
              //           children: folderListTiles,
              //         ),
              //         SizedBox(
              //           height: 100,
              //           child: ListView(

              //             scrollDirection: Axis.horizontal,
              //             shrinkWrap: true,
              //             children: cardListTiles,
              //           ),
              //         ),
              //       ],
              //     );
              //   }
              //   // if (state is EditSubjectCardsFetchingSuccess) {
              //   //   return ListView.builder(
              //   //     itemCount: state.cards.length,
              //   //     scrollDirection: Axis.vertical,
              //   //     itemBuilder: (context, index) =>
              //   //         CardListTile(card: state.cards[index]),
              //   //     shrinkWrap: true,
              //   //   );
              //   // }
              //   return Text("error");
              // })
            ],
          ),
        ),
      )),
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

  Future<void> save(GlobalKey<FormState> formKey, String nameInput,
      String iconInput, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (!nothingChanged(
          nameInput.trim(), iconInput.trim(), widget.subjectToEdit)) {
        context.read<EditSubjectBloc>().add(EditSubjectSaveSubject(widget
            .subjectToEdit
            .copyWith(name: nameInput, prefixIcon: iconInput)));
      }
    }
  }

  // TODO finish method
  // void addListTile(Object object) {
  //   if (object is Folder) {
  //     widget.subjectChildTiles.forEach((element) {
  //       if (element is FolderListTile) {
  //         if ((element as FolderListTile).folder.id == (object as Folder).id) {
  //           widget.subjectChildTiles.remove(element);
  //           widget.subjectChildTiles.add(FolderListTile(folder: object));
  //         }
  //       }
  //     });
  //   } else if (object is Card) {}
  // }

  @override
  void dispose() {
    _editSubjectBloc
        .add(EditSubjectCloseStreamById(id: widget.subjectToEdit.id));
    super.dispose();
  }
}
