import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_text_field_large.dart';class AddFolderBottomSheet extends StatefulWidget {
  const AddFolderBottomSheet({
    super.key,
    required this.parentId,
    this.parentSubject,
    this.parentFolder,
  });

  final String parentId;
  final Subject? parentSubject;
  final Folder? parentFolder;

  @override
  State<AddFolderBottomSheet> createState() => _AddFolderBottomSheetState();
}

class _AddFolderBottomSheetState extends State<AddFolderBottomSheet> {
  bool canSave = false;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void trySaveFolder() {
      final folderUID = Uid().uid();
      if (canSave) {
        context.read<SubjectBloc>().add(
              SubjectAddFolder(
                name: nameController.text,
                parentId: widget.parentId,
                folderId: folderUID,
              ),
            );
        if (context.read<SubjectOverviewSelectionBloc>().isInSelectMode) {
          context
              .read<SubjectOverviewSelectionBloc>()
              .add(SubjectOverviewSelectionMoveSelection(parentId: folderUID));
        }
        Navigator.pop(context);
      }
    }

    return UIBottomSheet(
      actionLeft: UIIconButton(
        icon: UIIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Add Folder', style: UIText.label),
      actionRight: UIButton(
        onPressed: trySaveFolder,
        child: Text(
          'Save',
          style: UIText.labelBold.copyWith(
            color: canSave ? UIColors.primary : UIColors.primaryDisabled,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: UIIcons.folder.copyWith(color: UIColors.smallText),
              ),
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              Expanded(
                child: UITextFieldLarge(
                  controller: nameController,
                  autofocus: true,
                  onChanged: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      setState(() {
                        canSave = false;
                      });
                    } else {
                      setState(() {
                        canSave = true;
                      });
                    }
                  },
                  onFieldSubmitted: (p0) {
                    trySaveFolder();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge),
        ],
      ),
    );
  }
}
