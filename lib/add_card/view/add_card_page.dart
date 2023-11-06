import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/add_card_settings_bottom_sheet.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key, required this.card, required this.parentId});

  final Card card;
  final String? parentId;
  TextEditorBloc? textEditorBloc;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        List<EditorTile>? editorTiles;
        if (textEditorBloc != null) {
          editorTiles = textEditorBloc!.editorTiles;
          await context.read<AddCardCubit>().saveCard(
                card,
                parentId,
                editorTiles,
              );
        }
        return true;
      },
      child: UIPage(
        addPadding: false,
        appBar: UIAppBar(
          leadingBackButton: true,
          leadingBackButtonPressed: () {
            List<EditorTile>? editorTiles;
            if (textEditorBloc != null) {
              editorTiles = textEditorBloc!.editorTiles;
              context.read<AddCardCubit>().saveCard(
                    card,
                    parentId,
                    editorTiles,
                  );
            }
          },
          actions: [
            UIIconButton(
              icon: UIIcons.settings,
              onPressed: () {
                UIBottomSheet.showUIBottomSheet(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<AddCardCubit>(),
                      child: AddCardSettingsBottomSheet(
                        card: card,
                        parentId: parentId,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: context.read<AddCardCubit>().getSavedEditorTiles(card),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              textEditorBloc = TextEditorBloc(
                context.read<AddCardCubit>().cardsRepository,
                (tiles) => context
                    .read<AddCardCubit>()
                    .saveCard(card, parentId, tiles),
                snapshot.data!,
                parentId,
              );
              return BlocProvider.value(
                value: textEditorBloc!,
                child: Stack(
                  children: [
                    MarkdownWidget(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: KeyboardRow(),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
