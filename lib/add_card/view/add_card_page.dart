import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/add_card_settings_bottom_sheet.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:ui_components/ui_components.dart';

class AddCardPage extends StatefulWidget {
  AddCardPage({super.key, required this.card, required this.parentId});

  final Card card;
  final String? parentId;

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> with WidgetsBindingObserver {
  TextEditorBloc? textEditorBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // when app gets minimized
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // App gets minimized
      _saveEditorTiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveEditorTiles();
        return true;
      },
      child: UIPage(
        addPadding: false,
        appBar: UIAppBar(
          leadingBackButton: true,
          leadingBackButtonPressed: _saveEditorTiles,
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
                        card: widget.card,
                        parentId: widget.parentId,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: context.read<AddCardCubit>().getSavedEditorTiles(widget.card),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              textEditorBloc = TextEditorBloc(
                context.read<AddCardCubit>().cardsRepository,
                (tiles) => context
                    .read<AddCardCubit>()
                    .saveCard(widget.card, widget.parentId, tiles),
                snapshot.data!,
                widget.parentId,
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

  Future<void> _saveEditorTiles() async {
    List<EditorTile>? editorTiles;
    if (textEditorBloc != null) {
      editorTiles = textEditorBloc!.editorTiles;
      await context.read<AddCardCubit>().saveCard(
            widget.card,
            widget.parentId,
            editorTiles,
          );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
