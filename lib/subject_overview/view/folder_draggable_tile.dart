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
        color: UIColors.onOverlayCard,
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultSize * 1.5,
          vertical: UIConstants.defaultSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder,
              color: UIColors.textLight,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.defaultSize * 2,
                vertical: UIConstants.defaultSize,
              ),
              child: SizedBox(
                width: UIConstants.defaultSize * 10,
                child: DefaultTextStyle(
                  //* or else yellow lines below text
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Text(folder.name,
                      overflow: TextOverflow.ellipsis, style: UIText.label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
