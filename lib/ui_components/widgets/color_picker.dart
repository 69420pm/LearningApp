// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/ui_components/backend/ui_repository.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';

class UIColorPicker extends StatefulWidget {
  UIColorPicker({
    super.key,
    required this.onColorChanged,
    this.showRemoveButton = false,
  });

  final void Function(Color?, bool?) onColorChanged;
  bool showRemoveButton;

  @override
  State<UIColorPicker> createState() => _UIColorPickerState();
}

class _UIColorPickerState extends State<UIColorPicker> {
  bool showColorWheel = false;
  Color currentColorInColorWheel = Colors.black;
  final int maxRecentColors = 16;

  @override
  Widget build(BuildContext context) {
    //TODO save and load
    final ownColors = context.read<UIRepository>().getCustomColors();
    var recentColors = context.read<UIRepository>().getRecentColors();
    if (recentColors.length > maxRecentColors) {
      recentColors = recentColors.sublist(
        recentColors.length - maxRecentColors,
        recentColors.length,
      );
    }
    final colorWheel = [
      ColorPicker(
        pickerColor: currentColorInColorWheel,
        paletteType: PaletteType.hsl,
        onColorChanged: (value) {
          currentColorInColorWheel = value;
        },
        colorHistory: defaultColors,
        enableAlpha: false,
        labelTypes: const [],
        pickerAreaBorderRadius:
            const BorderRadius.all(Radius.circular(UIConstants.cornerRadius)),
      ),
      // UIButton(
      //   label: 'Save',
      //   onTap: () => setState(() {
      //     if (!recentColors.contains(currentColorInColorWheel)) {
      //       recentColors.add(currentColorInColorWheel);
      //       context.read<UIRepository>().saveRecentColors(recentColors);
      //     }
      //     showColorWheel = false;
      //     widget.onColorChanged(currentColorInColorWheel, false);
      //     ownColors.add(currentColorInColorWheel);
      //     context.read<UIRepository>().saveCustomColors(ownColors);
      //   }),
      //   color: Theme.of(context).colorScheme.primaryContainer,
      // ),
    ];

    final colorGrids = [
      Text(
        'Recent Colors',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      ColorGridView(
        children: List.generate(
          recentColors.length,
          (index) {
            return ColorButton(
              color: recentColors[index],
              onPressed: () =>
                  widget.onColorChanged(recentColors[index], false),
            );
          },
        ),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      Text(
        'Default Colors',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      ColorGridView(
        children: List.generate(
          widget.showRemoveButton
              ? defaultColors.length + 1
              : defaultColors.length,
          (index) {
            if (index < defaultColors.length) {
              return ColorButton(
                color: defaultColors[index],
                onPressed: () {
                  widget.onColorChanged(defaultColors[index], false);
                  setState(() {
                    if (!recentColors.contains(defaultColors[index])) {
                      recentColors.add(defaultColors[index]);
                      context
                          .read<UIRepository>()
                          .saveRecentColors(recentColors);
                    }
                  });
                },
              );
            } else {
              final gradient = LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onBackground,
                  Theme.of(context).colorScheme.background,
                ],
              );
              return GestureDetector(
                onTap: () => widget.onColorChanged(null, true),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(UIConstants.cornerRadius),
                      ),
                      child: Transform.rotate(
                        angle: 1 / 4 * pi,
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => gradient.createShader(
                            Rect.fromLTRB(bounds.width / 2 - 1, 0,
                                bounds.width / 2, bounds.height,),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(UIConstants.cornerRadius),
                          ),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: UIConstants.borderWidth * 2,),),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      Text(
        'Own Colors',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      ColorGridView(
        children: List.generate(
          ownColors.length + 1,
          (index) {
            if (index == ownColors.length) {
              return IconButton(
                onPressed: () => setState(() => showColorWheel = true),
                icon: const Icon(Icons.add),
              );
            }
            return ColorButton(
              color: ownColors[index],
              onPressed: () {
                widget.onColorChanged(ownColors[index], false);
                setState(() {
                  if (!recentColors.contains(ownColors[index])) {
                    recentColors.add(ownColors[index]);

                    context.read<UIRepository>().saveRecentColors(recentColors);
                  }
                });
              },
            );
          },
        ),
      ),
    ];

    return UIBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: showColorWheel ? colorWheel : colorGrids,
      ),
    );
  }
}

class ColorGridView extends StatelessWidget {
  const ColorGridView({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 8,
      crossAxisSpacing: UIConstants.defaultSize,
      mainAxisSpacing: UIConstants.defaultSize,
      children: children,
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({super.key, required this.color, required this.onPressed});

  final Color color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
        ),
      ),
    );
  }
}
