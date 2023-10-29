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
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:learning_app/subject_overview/view/subject_card.dart';
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
  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();
    final scrollController = ScrollController();

    var isMovingDown = false;
    var isMovingUp = false;
    print("rebuilt");
    final softSelectedFolder = widget.cardsRepository.getFolderById(
        context.read<SubjectOverviewSelectionBloc>().folderUIDSoftSelected);

    return UIPage(
      appBar: UIAppBar(
        leadingBackButton:
            context.read<SubjectOverviewSelectionBloc>().isInSelectMode,
        leading: context.read<SubjectOverviewSelectionBloc>().isInSelectMode
            ? UIIconButton(
                icon: UIIcons.close,
                onPressed: () =>
                    context.read<SubjectOverviewSelectionBloc>().add(
                          SubjectOverviewSelectionToggleSelectMode(
                            inSelectMode: false,
                          ),
                        ),
              )
            : null,
        actions: context.read<SubjectOverviewSelectionBloc>().isInSelectMode
            ? []
            : context.read<SubjectOverviewSelectionBloc>().isInSelectMode
                ? [
                    UIIconButton(
                      icon: UIIcons.edit,
                      onPressed: () => UIBottomSheet.showUIBottomSheet(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: context.read<FolderListTileBloc>(),
                            child: EditFolderBottomSheet(
                              folder: softSelectedFolder!,
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                : [
                    UIIconButton(
                      icon: UIIcons.settings,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/subject_overview/edit_subject',
                          arguments: widget.subjectToEdit,
                        );
                      },
                    ),
                  ],
      ),
      body: Column(
        children: [
          SubjectCard(
            subject: widget.subjectToEdit,
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          UILabelRow(
            labelText: 'Files',
            actionWidgets: [
              UIIconButton(
                icon: UIIcons.search.copyWith(color: UIColors.smallText),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/search',
                    arguments: widget.subjectToEdit.uid,
                  );
                },
              ),
              UIIconButton(
                icon: UIIcons.download.copyWith(color: UIColors.smallText),
                onPressed: () {
                  context.read<SubjectBloc>().add(
                        SubjectAddCard(
                          front: "test",
                          back: "test Back",
                          parentId: softSelectedFolder != null
                              ? softSelectedFolder.uid
                              : widget.subjectToEdit.uid,
                        ),
                      );
                },
              ),
              UIIconButton(
                icon: UIIcons.addFolder.copyWith(color: UIColors.smallText),
                onPressed: () {
                  UIBottomSheet.showUIBottomSheet(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<SubjectBloc>(),
                        child: AddFolderBottomSheet(
                          parentId: softSelectedFolder != null
                              ? softSelectedFolder.uid
                              : widget.subjectToEdit.uid,
                        ),
                      );
                    },
                  );
                },
              ),
              UIIconButton(
                icon: UIIcons.placeHolder.copyWith(color: UIColors.smallText),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/add_card',
                    arguments: softSelectedFolder != null
                        ? softSelectedFolder.uid
                        : widget.subjectToEdit.uid,
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          ValueListenableBuilder(
            valueListenable: context
                .read<SubjectBloc>()
                .cardsRepository
                .getChildrenById(widget.subjectToEdit.uid),
            builder: (context, value, child) {
              final _folders = value.whereType<Folder>().toList();
              final _cards = value.whereType<Card>().toList();

              print('rebuilt cardrebository');

              return ValueListenableBuilder(
                valueListenable: context
                    .read<SubjectOverviewSelectionBloc>()
                    .selectedFilesNotifier,
                builder: (context, _, __) {
                  print('rebuilt selection');
                  return Expanded(
                    child: Stack(
                      children: [
                        DragTarget(
                          onAccept: (data) {
                            if (data is Folder) {
                              context.read<SubjectBloc>().add(
                                    SubjectSetFolderParent(
                                      folder: data,
                                      parentId: widget.subjectToEdit.uid,
                                    ),
                                  );
                            } else if (data is Card) {
                              if (context
                                  .read<SubjectOverviewSelectionBloc>()
                                  .isInSelectMode) {
                                context
                                    .read<SubjectOverviewSelectionBloc>()
                                    .add(
                                      SubjectOverviewSelectionMoveSelection(
                                        parentId: widget.subjectToEdit.uid,
                                      ),
                                    );
                              } else {
                                context
                                    .read<SubjectOverviewSelectionBloc>()
                                    .add(
                                      SubjectOverviewSelectionToggleSelectMode(
                                        inSelectMode: true,
                                      ),
                                    );
                                context
                                    .read<SubjectOverviewSelectionBloc>()
                                    .add(
                                      SubjectOverviewCardSelectionChange(
                                        cardUID: data.uid,
                                      ),
                                    );
                              }
                            }
                            // print(data);
                            // folder.childFolders.add(data);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Listener(
                              onPointerMove: (event) {
                                if (context
                                        .read<SubjectOverviewSelectionBloc>()
                                        .isInDragging ||
                                    context
                                        .read<FolderListTileBloc>()
                                        .isDragging) {
                                  final render = globalKey.currentContext
                                      ?.findRenderObject() as RenderBox?;
                                  final top =
                                      render?.localToGlobal(Offset.zero).dy ??
                                          0;
                                  final bottom =
                                      MediaQuery.of(context).size.height;

                                  final relPos =
                                      (event.localPosition.dy / (bottom - top))
                                          .clamp(0, 1);

                                  const space = 0.3;

                                  if (relPos < space && isMovingUp == false) {
                                    isMovingUp = true;
                                    isMovingDown = false;

                                    scrollController.animateTo(
                                      0,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeIn,
                                    );
                                  } else if (relPos > 1 - space &&
                                      isMovingDown == false) {
                                    isMovingDown = true;
                                    isMovingUp = false;
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeIn,
                                    );
                                  } else if (relPos > space &&
                                      relPos < 1 - space) {
                                    if (isMovingUp || isMovingDown) {
                                      scrollController.jumpTo(
                                        scrollController.offset,
                                      );
                                    }
                                    isMovingDown = false;
                                    isMovingUp = false;
                                  }
                                }
                              },
                              child: CustomScrollView(
                                key: globalKey,
                                controller: scrollController,
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => FolderListTileParent(
                                        folder: _folders[index],
                                      ),
                                      // ..isHighlight = index.isOdd,
                                      childCount: _folders.length,
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) =>
                                          CardListTile(card: _cards[index]),
                                      childCount: _cards.length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // SingleChildScrollView(child: FolderListTile(folder: Folder(dateCreated: "",id: "root",), cardsRepository: ,),)
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // bool nothingChanged(String name, String icon, Subject currentSubject) {
  //   if (name != currentSubject.name ||
  //       // location != currentSubject.parentId ||
  //       ) {
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> save(
  //   GlobalKey<FormState> formKey,
  //   String nameInput,
  //   String iconInput,
  //   BuildContext context,
  // ) async {
  //   if (formKey.currentState!.validate()) {
  //     if (!nothingChanged(
  //       nameInput.trim(),
  //       iconInput.trim(),
  //       widget.subjectToEdit,
  //     )) {
  //       context.read<SubjectBloc>().add(
  //             SubjectSaveSubject(
  //               widget.subjectToEdit
  //                   .copyWith(name: nameInput, prefixIcon: iconInput),
  //             ),
  //           );
  //     }
  //   }
  // }

  @override
  void dispose() {
    widget.editSubjectBloc
        .add(SubjectCloseStreamById(id: widget.subjectToEdit.uid));
    super.dispose();
  }
}
