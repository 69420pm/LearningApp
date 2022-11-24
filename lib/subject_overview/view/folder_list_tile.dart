import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: UISizeConstants.defaultSize * 2,
            vertical: UISizeConstants.defaultSize),
        child: Text(
          folder.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.all(
          Radius.circular(UISizeConstants.cornerRadius),
        ),
      ),
    );
  }
}
