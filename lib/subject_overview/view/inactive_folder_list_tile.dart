import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ui_components/ui_components.dart';

class InactiveFolderListTile extends StatelessWidget {
  const InactiveFolderListTile({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    GlobalKey expansionTileKey = GlobalKey();
    return Stack(
      children: [ExpansionTile(
        key: expansionTileKey,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(UISizeConstants.cornerRadius)),
              // backgroundColor: isHighlight
              //     ? Theme.of(context).colorScheme.onBackground.withOpacity(0.05)
              //     : Theme.of(context).colorScheme.onBackground.withOpacity(0.01),
              // collapsedBackgroundColor: isHighlight
              //     ? Theme.of(context).colorScheme.onBackground.withOpacity(0.05)
              //     : Theme.of(context).colorScheme.onBackground.withOpacity(0.01),
              controlAffinity: ListTileControlAffinity.leading,
              collapsedTextColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              textColor: Theme.of(context).colorScheme.onSecondaryContainer,
              maintainState: false,
              title: Row(
                children: [
                  const Icon(Icons.folder),
                  const SizedBox(
                    width: UISizeConstants.defaultSize * 1,
                  ),
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              // trailing: PopupMenuButton<int>(
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(UISizeConstants.cornerRadius),
              //     ),
              //   ),
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       value: 0,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Icon(Icons.delete),
              //           Text(
              //             'delete',
              //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //                   color: Theme.of(context).colorScheme.onSurface,
              //                 ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     PopupMenuItem(
              //       value: 1,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Icon(Icons.delete),
              //           Text(
              //             'spawn 20 cards',
              //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //                   color: Theme.of(context).colorScheme.onSurface,
              //                 ),
              //           ),
              //         ],
              //       ),
              //     )
              //   ],
              //   onSelected: (value) async {
              //     if (value == 0) {
              //       context.read<FolderListTileBloc>().add(
              //             FolderListTileDeleteFolder(
              //               id: folder.id,
              //               parentId: folder.parentId,
              //             ),
              //           );
              //     } else if (value == 1) {
              //       for (var i = 0; i <= 20; i++) {
              //         context.read<FolderListTileBloc>().add(
              //               FolderListTileDEBUGAddCard(
              //                 card: Card(
              //                   back: 'test$i',
              //                   front: 'test$i',
              //                   askCardsInverted: false,
              //                   id: const Uuid().v4(),
              //                   dateCreated: '',
              //                   parentId: folder.id,
              //                   dateToReview: DateTime.now().toIso8601String(),
              //                   typeAnswer: false,
              //                   tags: const [],
              //                 ),
              //               ),
              //             );
              //         await Future.delayed(const Duration(milliseconds: 5));
              //       }
              //     }
              //   },
              // ),
              // children: [
              //   Padding(
              //     padding: const EdgeInsets.only(
              //       left: UISizeConstants.defaultSize * 4,
              //     ),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         if (childListTiles.values
              //             .whereType<FolderListTile>()
              //             .isNotEmpty)
              //           ListView.builder(
              //             physics: const NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             itemCount: childListTiles.values
              //                 .whereType<FolderListTile>()
              //                 .length,
              //             itemBuilder: (context, index) => childListTiles.values
              //                 .whereType<FolderListTile>()
              //                 .elementAt(index)
              //               ..isHighlight = index.isOdd,
              //           ),
              //         if (childListTiles.values
              //             .whereType<CardListTile>()
              //             .isNotEmpty)
              //           ListView.builder(
              //             physics: const NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             itemCount: childListTiles.values
              //                 .whereType<CardListTile>()
              //                 .length,
              //             itemBuilder: (context, index) => childListTiles.values
              //                 .whereType<CardListTile>()
              //                 .elementAt(index)
              //               ..isHighlight = index.isOdd
              //               ..isInSelectMode = inSelectionMode,
              //           ),
              //       ],
              //     ),
              //   ),
              // ],
            ),
            Container(
              color: Color.fromARGB(45, 255, 255, 255), width: 400, height: 58)]
    );
  }
}