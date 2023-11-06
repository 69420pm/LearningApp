import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/add_folder/view/edit_folder_bottom_sheet.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/dragging_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:learning_app/subject_overview/view/subject_page/subject_card.dart';
import 'package:learning_app/subject_overview/view/subject_page/subject_page_app_bar.dart';
import 'package:learning_app/subject_overview/view/subject_page/subject_page_auto_scroller.dart';
import 'package:learning_app/subject_overview/view/subject_page/subject_page_tool_bar.dart';
import 'package:ui_components/ui_components.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({
    super.key,
    required this.subjectToEdit,
    required this.editSubjectBloc,
    required this.cardsRepository,
  });
  final Subject subjectToEdit;
  final SubjectBloc editSubjectBloc;
  final CardsRepository cardsRepository;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectBloc(cardsRepository),
      child: Builder(
        builder: (context) {
          context
              .read<SubjectBloc>()
              .add(SubjectGetChildrenById(id: subjectToEdit.uid));
          return SubjectView(
            subjectToEdit: subjectToEdit,
            editSubjectBloc: editSubjectBloc,
            cardsRepository: cardsRepository,
          );
        },
      ),
    );
  }
}

class SubjectView extends StatefulWidget {
  const SubjectView({
    super.key,
    required this.subjectToEdit,
    required this.editSubjectBloc,
    required this.cardsRepository,
  });

  final Subject subjectToEdit;
  final SubjectBloc editSubjectBloc;
  final CardsRepository cardsRepository;

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  final globalKey = GlobalKey();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: SubjectPageAppBar(
          cardsRepository: widget.cardsRepository,
          subjectToEdit: widget.subjectToEdit),
      body: Column(
        children: [
          SubjectCard(
            subject: widget.subjectToEdit,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          SubjectPageToolBar(
              cardsRepository: widget.cardsRepository,
              subjectToEditUID: widget.subjectToEdit.uid),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Expanded(
            child: AutoScrollView(
              globalKey: globalKey,
              scrollController: scrollController,
              child: DraggingTile(
                fileUID: widget.subjectToEdit.uid,
                cardsRepository: widget.cardsRepository,
                child: ValueListenableBuilder(
                  valueListenable: context
                      .read<SubjectBloc>()
                      .cardsRepository
                      .getChildrenById(widget.subjectToEdit.uid),
                  builder: (context, value, child) {
                    final folder = value.whereType<Folder>().toList();
                    final card = value.whereType<Card>().toList();
                    return CustomScrollView(
                      key: globalKey,
                      controller: scrollController,
                      slivers: [
                        if (folder.isNotEmpty)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => FolderListTileParent(
                                folder: folder[index],
                                cardsRepository: widget.cardsRepository,
                              ),
                              // ..isHighlight = index.isOdd,
                              childCount: folder.length,
                            ),
                          ),
                        if (card.isNotEmpty)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => CardListTile(
                                card: card[index],
                                cardsRepository: widget.cardsRepository,
                              ),
                              childCount: card.length,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.editSubjectBloc
        .add(SubjectCloseStreamById(id: widget.subjectToEdit.uid));
    super.dispose();
  }
}
