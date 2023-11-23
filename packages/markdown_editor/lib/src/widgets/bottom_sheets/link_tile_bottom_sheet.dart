import 'package:flutter/material.dart' hide Card;
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/cubit/link_tile_bottom_sheet_cubit.dart';
import 'package:ui_components/ui_components.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:cards_api/cards_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkTileBottomSheet extends StatefulWidget {
  LinkTileBottomSheet({super.key});

  @override
  State<LinkTileBottomSheet> createState() => _LinkTileBottomSheetState();
}

class _LinkTileBottomSheetState extends State<LinkTileBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.4;
    return UIBottomSheet(
      title: const Text('Card Link', style: UIText.label),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          children: [
            UISearchTextField(
                onChanged: (text) {
                  if (text.trim().isEmpty) {
                    context.read<LinkTileBottomSheetCubit>().resetState();
                  } else {
                    context.read<LinkTileBottomSheetCubit>().request(text);
                  }
                  // setState(() {
                  //   searchResults = [];
                  //   widget._cardsRepository
                  //       .searchCard(text, null)
                  //       .forEach((element) {
                  //     searchResults.add(
                  //       _SearchEntry(
                  //         card: element.searchedObject as Card,
                  //         cardsRepository: widget._cardsRepository,
                  //       ),
                  //     );
                  //   });
                  // });
                },
                onCard: true,
                hintText: 'select card'),

            const SizedBox(
              height: UIConstants.itemPaddingLarge,
            ),
            BlocBuilder<LinkTileBottomSheetCubit, LinkTileBottomSheetState>(
              builder: (context, state) {
                if (state is LinkTileBottomSheetSuccess) {
                  final searchResults = <Widget>[];
                  context
                      .read<LinkTileBottomSheetCubit>()
                      .cardSearchResults
                      .forEach((element) {
                    searchResults.add(
                        _SearchEntry(card: element.searchedObject as Card));
                  });

                  return Scrollbar(
                    interactive: true,
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverList.list(children: searchResults),
                      ],
                    ),
                  );
                } else if (state is LinkTileBottomSheetNothingFound) {
                  return Text(
                    'Nothing found',
                    style: UIText.label.copyWith(color: UIColors.smallText),
                  );
                } else {
                  return Container();
                }
              },
            )

            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: searchResults.length,
            //   itemBuilder: (context, index) {
            //   return searchResults[index];
            // })
          ],
        ),
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  _SearchEntry({required this.card});
  Card card;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<TextEditorBloc>().add(TextEditorAddEditorTile(
            newEditorTile: LinkTile(
              cardId: card.uid,
            ),
            context: context));
            Navigator.of(context).pop();
        // UIBottomSheet.showUIBottomSheet(
        //   context: context,
        //   builder: (_) {
        //     return CardPreviewBottomSheet(
        //       card: card,
        //       cardsRepository: cardsRepository,
        //     );
        //   },
        // );
      },
      child: Column(
        children: [
          const SizedBox(
            height: UIConstants.itemPadding / 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              UIIcons.card,
              const SizedBox(
                width: UIConstants.itemPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // card.front was there before
                    Text(card.name, style: UIText.labelBold),
                    const SizedBox(
                      height: UIConstants.itemPadding / 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: UIConstants.itemPadding,
              ),
              UIIcons.arrowForwardMedium.copyWith(color: UIColors.smallText),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding / 4,
          ),
        ],
      ),
    );
  }
}
