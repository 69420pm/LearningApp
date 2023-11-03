import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/add_card_settings_bottom_sheet.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key, required this.card, required this.parentId});

  /// when add_Card_page is used as edit_Card_page, when not let it empty
  // final String parentId;

  Card card;
  final String? parentId;

  @override
  Widget build(BuildContext context) {
    // final frontController = TextEditingController();
    // final backController = TextEditingController();

    // final formKey = GlobalKey<FormState>();
    context.read<TextEditorBloc>().card = card;
    context.read<TextEditorBloc>().parentId = parentId;
    context
        .read<TextEditorBloc>()
        .add(TextEditorGetSavedEditorTiles(context: context));

    return UIPage(
      addPadding: false,
      appBar: UIAppBar(
        leadingBackButton: true,
        actions: [
          UIIconButton(
            icon: UIIcons.settings,
            onPressed: () {
              UIBottomSheet.showUIBottomSheet(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<AddCardCubit>(),
                    child: AddCardSettingsBottomSheet(
                      card: card,
                      parentId: parentId,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Stack(children: [
        MarkdownWidget(),
        Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: KeyboardRow(),
            )),
      ]),
    );
    // return Scaffold(
    //   backgroundColor: Theme.of(context).colorScheme.background,
    //   appBar: UIAppBar(title: 'Add Card Page'),
    //   body: Stack(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //             horizontal: UIConstants.cardHorizontalPadding),
    //         child: SafeArea(
    //           child: Form(
    //             key: formKey,
    //             child: Column(
    //               children: [
    //                 const SizedBox(height: UIConstants.defaultSize * 1),
    //                 UITextFormField(
    //                   onFieldSubmitted: (value) async {
    //                     if (formKey.currentState!.validate()) {
    //                       // await context.read<AddCardCubit>().saveCard(
    //                       //     frontController.text,
    //                       //     backController.text,
    //                       //     recommendedSubjectParent!,
    //                       //     iconController.text);
    //                       context.read<SubjectBloc>().add(
    //                             SubjectAddCard(
    //                               front: frontController.text,
    //                               back: backController.text,
    //                               parentId: widget.parentId,
    //                             ),
    //                           );
    //                     }
    //                     Navigator.pop(context);
    //                   },
    //                   autofocus: false,
    //                   label: 'Title',
    //                   controller: frontController,
    //                   validation: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Enter something';
    //                     } else {
    //                       return null;
    //                     }
    //                   },
    //                 ),
    //                 MarkdownWidget(),
    //                 ElevatedButton(
    //                   onPressed: () async {
    //                     if (formKey.currentState!.validate()) {
    //                       // await context.read<AddCardCubit>().saveCard(
    //                       //     frontController.text,
    //                       //     backController.text,
    //                       //     recommendedSubjectParent!,
    //                       //     iconController.text);
    //                       context.read<SubjectBloc>().add(
    //                             SubjectAddCard(
    //                               front: frontController.text,
    //                               back: backController.text,
    //                               parentId: widget.parentId,
    //                             ),
    //                           );
    //                     }
    //                     Navigator.pop(context);
    //                   },
    //                   child: const Text('Save'),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       Positioned(left: 0, right: 0, bottom: 0, child: KeyboardRow())
    //     ],
    //   ),
    // );
  }
}
