import 'package:cards_api/cards_api.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

// class AddSubjectPage extends StatelessWidget {
//   const AddSubjectPage({super.key, this.recommendedSubjectParentId});

//   final String? recommendedSubjectParentId;

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: UIAppBar(title: Text('Add subject')),
//       body: SafeArea(
//           child: ,
//     );
//   }
// }

class AddSubjectBottomSheet {
  AddSubjectBottomSheet(
      BuildContext context, String? recommendedSubjectParentId) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final iconController = TextEditingController();

    if (recommendedSubjectParentId != null) {
      locationController.text = recommendedSubjectParentId!;
    }

    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return UIBottomSheet(
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: UISizeConstants.paddingEdge,
                      vertical: UISizeConstants.defaultSize),
                  child: Column(
                    children: [
                      /// Name
                      UITextFormField(
                        controller: nameController,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return 'Enter something';
                          } else {
                            return null;
                          }
                        },
                        label: "Subject name",
                      ),

                      // /// File Location can be empty
                      // TextFormField(
                      //   controller: locationController,
                      // ),

                      // /// Prefix icon
                      // TextFormField(
                      //   controller: iconController,
                      // ),

                      UIButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await context.read<AddSubjectCubit>().saveSubject(
                                nameController.text,
                                locationController.text,
                                iconController.text);
                          }
                          Navigator.pop(context);
                        },
                        lable: "Save",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
