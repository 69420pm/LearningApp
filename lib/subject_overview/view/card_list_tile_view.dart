import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
class CardListTileView extends StatelessWidget {
  const CardListTileView({
    super.key,
    required this.card,
  });

  final Card card;

  @override
  Widget build(BuildContext context) {
    final selectionBloc = context.read<SubjectOverviewSelectionBloc>();
    final isSelected = selectionBloc.isFileSelected(card.uid);
    final isSoftSelected = selectionBloc.fileSoftSelected == card.uid;

    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
      child: Container(
        height: UIConstants.defaultSize * 5,
        decoration: BoxDecoration(
          color: isSoftSelected || isSelected
              ? UIColors.overlay
              : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: UIConstants.borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: UIConstants.defaultSize),
          child: Row(
            children: [
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
      ),
    );
  }
}
