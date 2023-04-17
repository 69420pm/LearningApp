import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:ui_components/ui_components.dart';

class FolderDraggableTile extends StatelessWidget {
  const FolderDraggableTile({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.all(
          Radius.circular(UISizeConstants.cornerRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UISizeConstants.defaultSize * 2,
          vertical: UISizeConstants.defaultSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UISizeConstants.defaultSize * 2,
                vertical: UISizeConstants.defaultSize,
              ),
              child: SizedBox(
                width: UISizeConstants.defaultSize * 10,
                child: Text(
                  folder.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
