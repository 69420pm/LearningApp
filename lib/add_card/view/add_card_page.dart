import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/edit_subject_bloc/subject_overview_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';

import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key, required this.parentId});

  /// when add_Card_page is used as edit_Card_page, when not let it empty
  final String parentId;

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final List<bool> _isOpen = [false, false];
  @override
  Widget build(BuildContext context) {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: UIAppBar(title: 'Add Card Page'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.cardHorizontalPadding),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: UIConstants.defaultSize * 1),
                    UITextFormField(
                      onFieldSubmitted: (value) async {
                        if (formKey.currentState!.validate()) {
                          // await context.read<AddCardCubit>().saveCard(
                          //     frontController.text,
                          //     backController.text,
                          //     recommendedSubjectParent!,
                          //     iconController.text);
                          context.read<EditSubjectBloc>().add(
                                EditSubjectAddCard(
                                  front: frontController.text,
                                  back: backController.text,
                                  parentId: widget.parentId,
                                ),
                              );
                        }
                        Navigator.pop(context);
                      },
                      autofocus: false,
                      label: 'Title',
                      controller: frontController,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Enter something';
                        } else {
                          return null;
                        }
                      },
                    ),
                    MarkdownWidget(),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // await context.read<AddCardCubit>().saveCard(
                          //     frontController.text,
                          //     backController.text,
                          //     recommendedSubjectParent!,
                          //     iconController.text);
                          context.read<EditSubjectBloc>().add(
                                EditSubjectAddCard(
                                  front: frontController.text,
                                  back: backController.text,
                                  parentId: widget.parentId,
                                ),
                              );
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: KeyboardRow())
        ],
      ),
    );
  }
}
