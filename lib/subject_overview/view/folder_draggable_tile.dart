import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class FolderDraggableTile extends StatelessWidget {
  const FolderDraggableTile({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UISizeConstants.defaultSize * 5,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(UISizeConstants.cornerRadius),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UISizeConstants.defaultSize * 2,
            vertical: UISizeConstants.defaultSize,
          ),
          child: Text(
            folder.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}
