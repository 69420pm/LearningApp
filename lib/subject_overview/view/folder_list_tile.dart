import 'package:cards_api/cards_api.dart' hide Card;
import 'package:cards_repository/cards_repository.dart' hide Card;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    List<FolderListTile> childFolders = List.empty(growable: true);
    // folder.childFolders.forEach(
    //   (element) => childFolders.add(FolderListTile(folder: element)),
    // );
    return Stack(children: [
      Draggable<Folder>(
        data: folder,
        feedback: const Text("folder"),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: UISizeConstants.defaultSize * 2,
                    vertical: UISizeConstants.defaultSize),
                child: Text(
                  "DICKHEAD",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
              children: childFolders,
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius),
            ),
          ),
        ),
      ),
      DragTarget<Folder>(
        onAccept: (data) {
          print(data);
          // folder.childFolders.add(data);
        },
        builder: (context, candidateData, rejectedData) =>
            Container(width: 100, height: 10, color: Colors.blue),
      )
    ]);
  }
}
