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
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 2,
          vertical: UIConstants.defaultSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.defaultSize * 2,
                vertical: UIConstants.defaultSize,
              ),
              child: SizedBox(
                width: UIConstants.defaultSize * 10,
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
