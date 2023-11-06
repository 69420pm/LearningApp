import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class AddClassTestPage extends StatelessWidget {
  AddClassTestPage({super.key, required this.classTest}) {
    addClassTest = classTest == null;
    if (!addClassTest) {
      nameController.text = classTest!.name;
      canSave = true;
    } else {
      classTest = ClassTest(
          uid: Uid().uid(), name: '', date: DateTime.now(), folderIds: const [],);
    }
  }

  ClassTest? classTest;
  bool addClassTest = true;
  final nameController = TextEditingController();
  bool canSave = false;

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      classTest = classTest!.copyWith(date: value);
      if (!addClassTest) {
        context.read<EditSubjectCubit>().saveClassTest(classTest!);
      } else {
        context.read<EditSubjectCubit>().changeClassTest(classTest!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UIPage(
      dismissFocusOnTap: true,
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (addClassTest)
            BlocBuilder<EditSubjectCubit, EditSubjectState>(
              buildWhen: (previous, current) =>
                  current is EditSubjectClassTestChanged,
              builder: (context, state) {
                if (state is EditSubjectClassTestChanged) {
                  canSave = state.canSave;
                }
                return UIButton(
                  child: Text(
                    'Save',
                    style: UIText.labelBold.copyWith(
                      color:
                          canSave ? UIColors.primary : UIColors.primaryDisabled,
                    ),
                  ),
                  onPressed: () {
                    if (canSave) {
                      context
                          .read<EditSubjectCubit>()
                          .saveClassTest(classTest!)
                          .then((value) => Navigator.pop(context));
                    }
                  },
                );
              },
            ),
        ],
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
                  autofocus: true,
                  onChanged: (p0) {
                    classTest = classTest!.copyWith(name: p0);
                    if (!addClassTest) {
                      context
                          .read<EditSubjectCubit>()
                          .saveClassTest(classTest!);
                    } else {
                      context
                          .read<EditSubjectCubit>()
                          .changeClassTest(classTest!);
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
          BlocBuilder<EditSubjectCubit, EditSubjectState>(
            buildWhen: (previous, current) =>
                current is EditSubjectClassTestChanged,
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
                    if (classTest!.date == '')
                      Row(
                        children: [
                          UIIconButton(
                            icon: UIIcons.add.copyWith(color: UIColors.primary),
                            onPressed: () {
                              _showDatePicker(context);
                            },
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          UIIconButton(
                            icon: UIIcons.arrowForwardSmall
                                .copyWith(color: UIColors.smallText),
                            onPressed: () {
                              _showDatePicker(context);
                            },
                            text: DateFormat('MM/dd/yyyy')
                                .format(classTest!.date),
                          ),
                          // Text(
                          //   DateFormat('MM/dd')
                          //       .format(DateTime.parse(classTest!.date)),
                          //   style: UIText.label,
                          // ),
                          // const SizedBox(
                          //   width: UIConstants.itemPadding * 0.5,
                          // ),
                          // UIIcons.arrowForwardSmall
                          //     .copyWith(color: UIColors.smallText),
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
          UILabelRow(
            labelText: 'Relevant Folders',
            horizontalPadding: true,
            actionWidgets: [
              UIIconButton(
                icon: UIIcons.add.copyWith(color: UIColors.smallText),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          if (!addClassTest)
            UIDeletionRow(
              deletionText: 'Delete Class Test',
              onPressed: () {
                context
                    .read<EditSubjectCubit>()
                    .deleteClassTest(classTest!)
                    .then((value) => Navigator.pop(context));
              },
            ),
        ],
      ),
    );
  }
}
