import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_edit_class_test/cubit/relevant_folders_cubit.dart';
import 'package:learning_app/add_edit_class_test/view/selectable_card_list_tile.dart';
import 'package:learning_app/add_edit_class_test/view/selectable_folder_list_tile.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';class RelevantFoldersPage extends StatelessWidget {
  const RelevantFoldersPage(
      {Key? key,
      required this.cardsRepository,
      required this.subjectToEdit,
      required this.classTest})
      : super(key: key);

  final CardsRepository cardsRepository;
  final Subject subjectToEdit;
  final ClassTest classTest;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RelevantFoldersCubit(cardsRepository, subjectToEdit, classTest),
      child: UIPage(
        appBar: const UIAppBar(
          title: 'Add Relevant Cards',
          leadingBackButton: true,
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable:
                  cardsRepository.getChildrenById(subjectToEdit.uid),
              builder: (context, value, child) {
                final folder = value.whereType<Folder>().toList();
                final card = value.whereType<Card>().toList();
                return CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    if (folder.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => SelectableFolderListTile(
                            folder: folder[index],
                            cardsRepository: cardsRepository,
                          ),
                          // ..isHighlight = index.isOdd,
                          childCount: folder.length,
                        ),
                      ),
                    if (card.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => SelectableCardListTile(
                            card: card[index],
                          ),
                          childCount: card.length,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
