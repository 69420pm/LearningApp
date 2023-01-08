import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:tex_markdown/tex_markdown.dart';
import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key, required this.parentId});

  /// when add_Card_page is used as edit_Card_page, when not let it empty
  final String parentId;

  @override
  Widget build(BuildContext context) {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: UIAppBar(title: const Text('Add Card Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AddCardCubit>().switchMarkdownMode(),
        child: BlocBuilder<AddCardCubit, AddCardState>(
          builder: (context, state) {
            if (state is AddCardRenderMode) {
              return Icon(Icons.edit);
            }
            return Icon(Icons.visibility);
          },
        ),
      ),
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
              // TextFormField(
              //   controller: backController,
              // ),

              /// File Location
              // TextFormField(
              //   controller: locationController,
              // ),
              BlocBuilder<AddCardCubit, AddCardState>(
                builder: (context, state) {
                  print(backController.text as String);
                  if (state is AddCardRenderMode) {
                    // return Expanded(
                    //   child:  Markdown(
                    //     data: backController.text,
                    //   ),
                    // );
                    return Expanded(child: 
                    TexMarkdown(
                      backController.text,
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      
                    ),);
                  }
                  return UITextFormField(
                    controller: backController,
                    initialValue: backController.text,
                    validation: (value) {
                      if (value!.isEmpty) {
                        return 'Enter something';
                      } else {
                        return null;
                      }
                    },
                    inputType: TextInputType.multiline,
                    maxLines: null,
                  );
                },
              ),

              /// Prefix icon
              // TextFormField(
              //   controller: iconController,
              // ),
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
                            parentId: parentId,
                          ),
                        );
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
