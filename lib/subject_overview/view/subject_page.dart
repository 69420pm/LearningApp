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
              .add(SubjectGetChildrenById(id: subjectToEdit.id));
          return SubjectView(
            subjectToEdit: subjectToEdit,
            editSubjectBloc: editSubjectBloc,
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
  });

  final Subject subjectToEdit;
  final SubjectBloc editSubjectBloc;
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

    var childListTiles = <String, Widget>{};

    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        var softSelectedFolder =
            context.read<SubjectOverviewSelectionBloc>().folderSoftSelected;
        return UIPage(
          appBar: UIAppBar(
            leadingBackButton: state is! SubjectOverviewSelectionModeOn,
            leading: state is SubjectOverviewSelectionModeOn
                ? UIIconButton(
                    icon: UIIcons.close,
                    onPressed: () =>
                        context.read<SubjectOverviewSelectionBloc>().add(
                              SubjectOverviewSelectionToggleSelectMode(
                                  inSelectMode: false),
                            ),
                  )
                : null,
            actions: state is SubjectOverviewSelectionModeOn
                ? []
                : state is SubjectOverviewSoftSelectionModeOn
                    ? [
                        UIIconButton(
                          icon: UIIcons.edit,
                          onPressed: () => UIBottomSheet.showUIBottomSheet(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: context.read<FolderListTileBloc>(),
                                child: EditFolderBottomSheet(
                                    folder: context
                                        .read<SubjectOverviewSelectionBloc>()
                                        .folderSoftSelected!),
                              );
                            },
                          ),
                        )
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
                      Navigator.of(context).pushNamed('/search',
                          arguments: widget.subjectToEdit.id);
                    },
                  ),
                  UIIconButton(
                    icon: UIIcons.download.copyWith(color: UIColors.smallText),
                    onPressed: () {
                      context.read<SubjectBloc>().add(SubjectAddCard(
                          front: "test",
                          back: "test Back",
                          parentId: softSelectedFolder != null
                              ? softSelectedFolder.id
                              : widget.subjectToEdit.id));
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
                                  ? softSelectedFolder.id
                                  : widget.subjectToEdit.id,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  UIIconButton(
                    icon:
                        UIIcons.placeHolder.copyWith(color: UIColors.smallText),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_card',
                          arguments: softSelectedFolder != null
                              ? softSelectedFolder.id
                              : widget.subjectToEdit.id);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: UIConstants.itemPaddingLarge,
              ),
              BlocBuilder<SubjectBloc, SubjectState>(
                buildWhen: (previous, current) {
                  if (current is SubjectRetrieveChildren) {
                    return true;
                  }
                  return false;
                },
                builder: (context, editSubjectState) {
                  if (editSubjectState is SubjectRetrieveChildren) {
                    childListTiles = {
                      ...childListTiles,
                      ...editSubjectState.childrenStream,
                    };

                    for (final element in editSubjectState.removedWidgets) {
                      if (childListTiles.containsKey(element.id)) {
                        childListTiles.remove(element.id);
                      }
                    }
                  }
                  return Expanded(
                    child: Stack(
                      children: [
                        DragTarget(
                          onAccept: (data) {
                            if (data is Folder) {
                              if (data.parentId == widget.subjectToEdit.id) {
                                return;
                              }
                              context.read<SubjectBloc>().add(
                                    SubjectSetFolderParent(
                                      folder: data,
                                      parentId: widget.subjectToEdit.id,
                                    ),
                                  );
                            } else if (data is Card) {
                              if (data.parentId != widget.subjectToEdit.id) {
                                if (context
                                        .read<SubjectOverviewSelectionBloc>()
                                        .state
                                    is SubjectOverviewSelectionMultiDragging) {
                                  context
                                      .read<SubjectOverviewSelectionBloc>()
                                      .add(
                                        SubjectOverviewSelectionMoveSelectedCards(
                                          parentId: widget.subjectToEdit.id,
                                        ),
                                      );
                                } else {
                                  context.read<SubjectBloc>().add(
                                        SubjectSetCardParent(
                                          card: data,
                                          parentId: widget.subjectToEdit.id,
                                        ),
                                      );
                                }
                              } else if (context
                                  .read<SubjectOverviewSelectionBloc>()
                                  .isInSelectMode) {
                                context
                                    .read<SubjectOverviewSelectionBloc>()
                                    .add(
                                      SubjectOverviewSelectionMoveSelectedCards(
                                        parentId: widget.subjectToEdit.id,
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
                                      SubjectOverviewSelectionChange(
                                        card: data,
                                        addCard: true,
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
                                      (context, index) => childListTiles.values
                                          .whereType<FolderListTileParent>()
                                          .elementAt(index),
                                      // ..isHighlight = index.isOdd,
                                      childCount: childListTiles.values
                                          .whereType<FolderListTileParent>()
                                          .length,
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => childListTiles.values
                                          .whereType<CardListTile>()
                                          .elementAt(index),
                                      childCount: childListTiles.values
                                          .whereType<CardListTile>()
                                          .length,
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
              ),
            ],
          ),
        );
      },
    );
  }

  bool nothingChanged(String name, String icon, Subject currentSubject) {
    if (name != currentSubject.name ||
        // location != currentSubject.parentId ||
        icon != currentSubject.prefixIcon) {
      return false;
    }
    return true;
  }

  Future<void> save(
    GlobalKey<FormState> formKey,
    String nameInput,
    String iconInput,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      if (!nothingChanged(
        nameInput.trim(),
        iconInput.trim(),
        widget.subjectToEdit,
      )) {
        context.read<SubjectBloc>().add(
              SubjectSaveSubject(
                widget.subjectToEdit
                    .copyWith(name: nameInput, prefixIcon: iconInput),
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    widget.editSubjectBloc
        .add(SubjectCloseStreamById(id: widget.subjectToEdit.id));
    super.dispose();
  }
}
