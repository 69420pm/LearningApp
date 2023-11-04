import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:ui_components/ui_components.dart';
import 'package:cards_repository/cards_repository.dart';

class SubjectPageToolBar extends StatelessWidget {
  const SubjectPageToolBar(
      {super.key,
      required this.cardsRepository,
      required this.subjectToEditUID});
  final CardsRepository cardsRepository;
  final String subjectToEditUID;
  @override
  Widget build(BuildContext context) {
    String? softSelectedFolderUID;
    return BlocListener<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      listener: (context, state) {
        final softSelectedFile = cardsRepository.objectFromId(
            context.read<SubjectOverviewSelectionBloc>().fileUIDSoftSelected);
        if (softSelectedFile is Folder) {
          softSelectedFolderUID = softSelectedFile.uid;
        }
      },
      listenWhen: (previous, current) =>
          current is SubjectOverviewSoftSelectionModeOn ||
          previous is SubjectOverviewSoftSelectionModeOn,
      child: UILabelRow(
        labelText: 'Files',
        actionWidgets: [
          UIIconButton(
            icon: UIIcons.search.copyWith(color: UIColors.smallText),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/search',
                arguments: subjectToEditUID,
              );
            },
          ),
          UIIconButton(
            icon: UIIcons.download.copyWith(color: UIColors.smallText),
            onPressed: () {
              context.read<SubjectBloc>().add(SubjectAddCard(
                  front: "test",
                  back: "test Back",
                  parentId: softSelectedFolderUID ?? subjectToEditUID));
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
                      parentId: softSelectedFolderUID ?? subjectToEditUID,
                    ),
                  );
                },
              );
            },
          ),
          UIIconButton(
            icon: UIIcons.card.copyWith(color: UIColors.smallText),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/add_card',
                arguments: [
                  Card(
                      uid: Uid().uid(),
                      dateCreated: DateTime.now(),
                      askCardsInverted: false,
                      typeAnswer: false,
                      recallScore: 0,
                      dateToReview: DateTime.now(),
                      name: ""),
                  subjectToEditUID,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
