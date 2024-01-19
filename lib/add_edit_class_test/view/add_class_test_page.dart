import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/add_edit_class_test/cubit/add_edit_class_test_cubit.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_text_field_large.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_container.dart';
import 'package:learning_app/ui_components/widgets/ui_deletion_row.dart';
import 'package:learning_app/ui_components/widgets/ui_description.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class AddClassTestPage extends StatelessWidget {
  AddClassTestPage({super.key, required this.addClassTest});

  bool addClassTest = true;
  final nameController = TextEditingController();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: context.read<AddEditClassTestCubit>().classTest!.date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 40000)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: UIColors.primary,
              onSurface: UIColors.textLight,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: UIColors.smallText,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value == null) return;

      // if (!addClassTest) {
      //   context.read<AddEditClassTestCubit>().saveClassTest(classTest!);
      // } else {
      context.read<AddEditClassTestCubit>().changeDate(value);
      // context.read<AddEditClassTestCubit>().changeClassTest(classTest!);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!addClassTest) {
      nameController.text =
          context.read<AddEditClassTestCubit>().classTest!.name;
    } else {
      nameController
        ..text = 'New Class Test'
        ..selection = TextSelection(
            baseOffset: 0, extentOffset: nameController.text.length);
    }
    // if(addClassTest){
    //   context.read<AddEditClassTestCubit>().saveClassTest(classTest!);
    // }
    return UIPage(
      dismissFocusOnTap: true,
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   if (addClassTest)
        //     BlocBuilder<AddEditClassTestCubit, AddEditClassTestState>(
        //       buildWhen: (previous, current) =>
        //           current is EditSubjectClassTestChanged,
        //       builder: (context, state) {
        //         if (state is EditSubjectClassTestChanged) {
        //           canSave = state.canSave;
        //         }
        //         return UIButton(
        //           child: Text(
        //             'Save',
        //             style: UIText.labelBold.copyWith(
        //               color:
        //                   canSave ? UIColors.primary : UIColors.primaryDisabled,
        //             ),
        //           ),
        //           onPressed: () {
        //             if (canSave) {
        //               context
        //                   .read<AddEditClassTestCubit>()
        //                   .saveClassTest(classTest!)
        //                   .then((value) => Navigator.pop(context));
        //             }
        //           },
        //         );
        //       },
        //     ),
        // ],
        title: addClassTest ? 'Add Class Test' : 'Edit Class Test',
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: UIIcons.classTest.copyWith(color: UIColors.smallText),
              ),
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              Expanded(
                child: UITextFieldLarge(
                  controller: nameController,
                  autofocus: addClassTest,
                  onChanged: (p0) {
                    if (p0!.trim().isNotEmpty) {
                      context.read<AddEditClassTestCubit>().changeName(p0);
                    }
                  },
                  // onFieldSubmitted: (_){},
                ),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          BlocBuilder<AddEditClassTestCubit, AddEditClassTestState>(
            buildWhen: (previous, current) =>
                current is AddEditClassTestChangedDate,
            builder: (context, state) {
              return UIContainer(
                padding: const EdgeInsets.only(
                  left: UIConstants.cardHorizontalPadding,
                  right: UIConstants.cardHorizontalPadding - 6,
                  top: UIConstants.cardVerticalPadding - 6,
                  bottom: UIConstants.cardVerticalPadding - 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date', style: UIText.label),
                    // Row(
                    //   children: [
                    //     UIIconButton(
                    //       icon: UIIcons.add.copyWith(color: UIColors.primary),
                    //       onPressed: () {
                    //         _showDatePicker(context);
                    //       },
                    //     ),
                    //   ],
                    // )
                    // else
                    Row(
                      children: [
                        UIIconButton(
                          icon: UIIcons.arrowForwardSmall
                              .copyWith(color: UIColors.smallText),
                          onPressed: () {
                            _showDatePicker(context);
                          },
                          text: DateFormat('MM/dd/yyyy').format(context
                              .read<AddEditClassTestCubit>()
                              .classTest!
                              .date),
                        ),
                        //       // Text( 
                        //       //   DateFormat('MM/dd')
                        //       //       .format(DateTime.parse(classTest!.date)),
                        //       //   style: UIText.label,
                        //       // ),
                        //       // const SizedBox(
                        //       //   width: UIConstants.itemPadding * 0.5,
                        //       // ),
                        //       // UIIcons.arrowForwardSmall
                        //       //     .copyWith(color: UIColors.smallText),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          BlocBuilder<AddEditClassTestCubit, AddEditClassTestState>(
            buildWhen: (previous, current) =>
                current is AddEditClassTestChangedRelevantCards,
            builder: (context, state) {
              final foldersAreEmpty =
        context.read<AddEditClassTestCubit>().classTest!.folderIds.isEmpty;
              return Column(
                children: [
                  UILabelRow(
                    labelText: 'Relevant Cards',
                    horizontalPadding: true,
                    actionWidgets: [
                      UIIconButton(
                        icon: UIIcons.add.copyWith(
                          color: foldersAreEmpty
                              ? UIColors.primary
                              : UIColors.smallText,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/subject_overview/edit_subject/add_class_test/relevant_folders',
                            arguments: 
                              context.read<AddEditClassTestCubit>(),
                            
                          ).then(
                            (value) {
                              // final classTests = context
                              //     .read<AddEditClassTestCubit>()
                              //     .cardsRepository
                              //     .getClassTests(context
                              //         .read<AddEditClassTestCubit>()
                              //         .subject!
                              //         .uid);
                              // classTests!.forEach((element) {
                              //   if (element.uid == classTest!.uid) {
                              //     classTest = element;
                              //   }
                              // });
                              // context
                              //     .read<AddEditClassTestCubit>()
                              //     .changeClassTest(classTest!);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Builder(
                    builder: (_) {
                      if (foldersAreEmpty) {
                        return UIContainer(
                          child: UIDescription(
                            text:
                                'Add exams with date to this subject to increase test frequency when approaching an exam, that you are always well prepared for your exams',
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: UIContainer(
                          child: Text(
                            '${context.read<AddEditClassTestCubit>().classTest!.folderIds.length} cards selected',
                            style: UIText.label
                                .copyWith(color: UIColors.smallText),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          if (!addClassTest)
            UIDeletionRow(
              deletionText: 'Delete Class Test',
              onPressed: () {
                context
                    .read<AddEditClassTestCubit>()
                    .deleteClassTest()
                    .then((value) => Navigator.pop(context));
              },
            ),
        ],
      ),
    );
  }
}
