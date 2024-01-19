import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_edit_class_test/cubit/relevant_folders_cubit.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class SelectableCardListTile extends StatelessWidget {
  SelectableCardListTile({super.key, required this.card});
  Card card;

  @override
  Widget build(BuildContext context) {
    bool? ticked = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        height: UIConstants.defaultSize * 5,
        child: Row(
          children: [
            BlocBuilder<RelevantFoldersCubit, RelevantFoldersState>(
              buildWhen: (previous, current) {
                if (current is RelevantFoldersUpdateCheckbox) {
                  if (current.files[card.uid] != ticked) {
                    return true;
                  }
                }
                return false;
              },
              builder: (context, state) {
                if (state is RelevantFoldersUpdateCheckbox) {
                  ticked = state.files[card.uid];
                }
                return Checkbox(
                  value: ticked,
                  tristate: true,
                  onChanged: (value) {
                    context.read<RelevantFoldersCubit>().changeCheckbox(
                          card.uid,
                          value ?? false,
                          context
                        );
                  },
                );
              },
            ),
            UIIcons.card,
            const SizedBox(width: UIConstants.defaultSize * 2),
            Expanded(
              child: Text(
                card.name,
                overflow: TextOverflow.ellipsis,
                style: UIText.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
