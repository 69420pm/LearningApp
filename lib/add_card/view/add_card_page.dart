import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/card_settings_page.dart';
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
      _saveEditorTiles(emptyWarning: false, leaveEditorAfterSaving: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveEditorTiles();
        return false;
      },
      child: UIPage(
        addPadding: false,
        appBar: UIAppBar(
          leading: UIIconButton(
            icon: UIIcons.arrowBack,
            onPressed: () async {
              await _saveEditorTiles();
            },
          ),
          // leadingBackButton: true,
          // leadingBackButtonPressed: _saveEditorTiles,
          actions: [
            UIIconButton(
              icon: UIIcons.settings,
              onPressed: () {
                Navigator.pushNamed(context, '/add_card/settings', arguments: [
                  widget.card,
                  widget.parentId,
                  textEditorBloc!.editorTiles
                ]);
                // UIBottomSheet.showUIBottomSheet(
                //   context: context,
                //   builder: (_) {
                //     return BlocProvider.value(
                //       value: context.read<AddCardCubit>(),
                //       child: CardSettingsPage(
                //         card: widget.card,
                //         parentId: widget.parentId,
                //       ),
                //     );
                //   },
                // );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: context.read<AddCardCubit>().getSavedEditorTiles(widget.card),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              textEditorBloc = TextEditorBloc(
                      (tiles) => context
                          .read<AddCardCubit>()
                          .saveCard(widget.card, widget.parentId, tiles),
                      snapshot.data!,
                      widget.parentId,
                    );
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: textEditorBloc! 
                  ),
                  BlocProvider(
                    create: (context) => KeyboardRowCubit(textEditorBloc!),
                  ),
                ],
                child: Stack(
                  children: [
                    EditorWidget(),
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

  Future<void> _saveEditorTiles(
      {bool emptyWarning = true, bool leaveEditorAfterSaving = true}) async {
    if (textEditorBloc != null) {
      final editorTiles = textEditorBloc!.editorTiles;
      var isEmpty = true;
      for (final element in editorTiles) {
        if (element is FrontBackSeparatorTile) {
          break;
        }
        if (element is ImageTile) {
          isEmpty = false;
          break;
        }
        if (element is AudioTile) {
          isEmpty = false;
          break;
        }
        if (element is LatexTile) {
          isEmpty = false;
          break;
        }
      }
      if (isEmpty) {
        final frontText = DataClassHelper.getFrontAndBackTextFromEditorTiles(
            editorTiles, false);
            if(frontText[0].trim().isEmpty && frontText[1].trim().isEmpty && leaveEditorAfterSaving){
              Navigator.of(context).pop();
              return;
            }
        if (frontText.isNotEmpty &&
            frontText[0].trim().isNotEmpty &&
            editorTiles.isNotEmpty) {
          // card content is not empty
          await context.read<AddCardCubit>().saveCard(
                widget.card,
                widget.parentId,
                editorTiles,
              );
          if (leaveEditorAfterSaving) {
            Navigator.of(context).pop();
          }
          return;
        } else {
          // card content is empty
          var leaveEditor = false;
          if (!emptyWarning) {
            if (leaveEditorAfterSaving) {
              Navigator.of(context).pop();
            }
            return;
          }
          await showDialog(
            context: context,
            builder: (_) => UIDialog(
              title: 'Front of card is empty',
              body:
                  'This card can not be saved, please add some content to the front of the card.',
              actions: [
                UIButton(
                  child: Text('Leave without saving',
                      style: UIText.labelBold.copyWith(color: UIColors.delete)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    leaveEditor = true;
                  },
                ),
                UIButton(
                  child: const Text('Keep editing', style: UIText.label),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ).then((value) {
            if (leaveEditor) {
              Navigator.of(context).pop();
              return;
            }
          });
        }
      } else {
        // card content is not empty
        await context.read<AddCardCubit>().saveCard(
              widget.card,
              widget.parentId,
              editorTiles,
            );
        if (leaveEditorAfterSaving) {
          Navigator.of(context).pop();
        }
        return;
      }

      return;
    } else {
      if (leaveEditorAfterSaving) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
