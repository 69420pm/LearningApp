import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_edit_class_test/cubit/relevant_folders_cubit.dart';
import 'package:learning_app/add_edit_class_test/view/selectable_card_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class SelectableFolderListTile extends StatelessWidget {
  const SelectableFolderListTile(
      {super.key, required this.cardsRepository, required this.folder});
  final CardsRepository cardsRepository;
  final Folder folder;
  @override
  Widget build(BuildContext context) {
    bool? ticked = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: ValueListenableBuilder(
          valueListenable: cardsRepository.getChildrenById(folder.uid),
          builder: (context, value, child) {
            return Row(
              children: [
                BlocBuilder<RelevantFoldersCubit, RelevantFoldersState>(
                buildWhen: (previous, current) {
                  if (current is RelevantFoldersUpdateCheckbox) {
                    if (current.files[folder.uid] != ticked) {
                      return true;
                    }
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is RelevantFoldersUpdateCheckbox) {
                    ticked = state.files[folder.uid];
                  }
                  return Checkbox(
                    value: ticked,
                    tristate: true,
                    onChanged: (value) {
                      context.read<RelevantFoldersCubit>().changeCheckbox(
                            folder.uid,
                            value ?? false,
                          );
                    },
                  );
                },
              ),
                UIExpansionTile(title: folder.name, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: UIConstants.defaultSize * 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: value.map(
                        (e) {
                          if (e is Folder) {
                            return SelectableFolderListTile(
                              folder: e,
                              cardsRepository: cardsRepository,
                            );
                          } else {
                            return SelectableCardListTile(
                              card: e as Card,
                            );
                          }
                        },
                      ).toList(),
                    ),
                  )
                ]),
              ],
            );
          }),
    );
  }
}
