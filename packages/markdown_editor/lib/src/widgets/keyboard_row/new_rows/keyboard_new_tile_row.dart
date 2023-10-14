import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/models/text_field_constants.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/add_audio_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/add_image_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/bottom_sheets/latex_bottom_sheet.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/callout_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/divider_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/header_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/latex_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/list_editor_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/quote_tile.dart';
import 'package:markdown_editor/src/widgets/editor_tiles/text_tile.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardNewTileRow extends StatelessWidget {
  const KeyboardNewTileRow({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyboardRowContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      icon: UIIcons.formatQuote,
                      onPressed: () {
                        context.read<KeyboardRowCubit>().addNewTile(
                              QuoteTile(),
                              textEditorBloc,
                              context,
                            );
                      },
                    ),
                    KeyboardButton(
                      icon: UIIcons.calloutTile,
                      onPressed: () {
                        context.read<KeyboardRowCubit>().addNewTile(
                              CalloutTile(),
                              textEditorBloc,
                              context,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      icon: UIIcons.alternateEmail,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      icon: UIIcons.functions,
                      onPressed: () {
                        final newLatexTile = LatexTile();
                        String latexText = "";
                        UIBottomSheet.showUIBottomSheet(
                          context: context,
                          builder: (_) => Wrap(
                            children: [
                              BlocProvider.value(
                                value: context.read<TextEditorBloc>(),
                                child: LatexBottomSheet(
                                  textEditingController:
                                      newLatexTile.textEditingController,
                                  latexText: newLatexTile.latexText,
                                  focusNode: newLatexTile.focusNode ??=
                                      FocusNode(),
                                  onChanged: (text) =>
                                      latexText = text,
                                ),
                              ),
                            ],
                          ),
                        ).whenComplete(() {
                          print(FocusManager.instance.primaryFocus.hashCode);
                          if (latexText.isNotEmpty) {
                            context.read<KeyboardRowCubit>().addNewTile(
                                  newLatexTile.copyWith(latexText: latexText),
                                  textEditorBloc,
                                  context,
                                );
                            // context.read<TextEditorBloc>().add(
                            //       TextEditorReplaceEditorTile(
                            //         tileToRemove: newLatexTile,
                            //         newEditorTile: newLatexTile.copyWith(
                            //             latexText: newLatexTile
                            //                 .textEditingController.text),
                            //         context: context,
                            //       ),
                            //     );
                          } else {
                            context.read<TextEditorBloc>().add(
                                  TextEditorRemoveEditorTile(
                                    tileToRemove: newLatexTile,
                                    context: context,
                                  ),
                                );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardRowContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    KeyboardButton(
                      icon: UIIcons.image,
                      onPressed: () {
                        UIBottomSheet.showUIBottomSheet(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<TextEditorBloc>(),
                            child: AddImageBottomSheet(),
                          ),
                        ).whenComplete(
                          () => context.read<KeyboardRowCubit>().expandText(),
                        );
                      },
                    ),
                    KeyboardButton(
                      icon: UIIcons.audio,
                      onPressed: () {
                        UIBottomSheet.showUIBottomSheet(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<TextEditorBloc>(),
                            child: AddAudioBottomSheet(),
                          ),
                        ).whenComplete(
                          () => context.read<KeyboardRowCubit>().expandText(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              KeyboardButton(
                icon: UIIcons.close.copyWith(size: 28),
                onPressed: () {
                  context.read<KeyboardRowCubit>().expandText();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.bigTitle,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        HeaderTile(
                                          textStyle:
                                              TextFieldConstants.headingBig,
                                          hintText: 'Heading big',
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                              KeyboardButton(
                                icon: UIIcons.smallTitle,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        HeaderTile(
                                          textStyle:
                                              TextFieldConstants.headingSmall,
                                          hintText: 'Heading small',
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.horizontalRule,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        TextTile(
                                          textStyle: TextFieldConstants.normal,
                                        ),
                                        textEditorBloc,
                                        context,
                                        emitState: false,
                                      );
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        DividerTile(),
                                        textEditorBloc,
                                        context,
                                        // emitState: false
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      KeyboardRowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              KeyboardButton(
                                icon: UIIcons.formatListBulleted,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        ListEditorTile(),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                              KeyboardButton(
                                icon: UIIcons.formatListNumbered,
                                onPressed: () {
                                  context.read<KeyboardRowCubit>().addNewTile(
                                        ListEditorTile(
                                          orderNumber: 1,
                                        ),
                                        textEditorBloc,
                                        context,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              KeyboardButton(
                icon: UIIcons.done.copyWith(color: UIColors.primary),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
