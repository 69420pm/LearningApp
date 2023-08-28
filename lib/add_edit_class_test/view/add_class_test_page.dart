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
      classTest = ClassTest(id: Uid().uid(), name: '', date: '', folderIds: []);
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
      classTest = classTest!.copyWith(date: value.toIso8601String());
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
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {},
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
                    context.read<EditSubjectCubit>().saveClassTest(classTest!);
                  },
                );
              },
            )
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date', style: UIText.label),
                    if (classTest!.date == '')
                      Row(
                        children: [
                          UIIconButton(
                            icon:
                                UIIcons.add.copyWith(color: UIColors.smallText),
                            onPressed: () {
                              _showDatePicker(context);
                            },
                            text: 'Add Date',
                          )
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
                                .format(DateTime.parse(classTest!.date)),
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
              )
            ],
          )
        ],
      ),
    );
  }
}
