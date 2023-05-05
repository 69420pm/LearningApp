// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ui_components/src/ui_constants.dart';
import 'package:ui_components/src/ui_constants.dart';
import 'package:ui_components/ui_components.dart';

class UIColorPicker extends StatefulWidget {
  UIColorPicker({
    super.key,
    required this.onColorChanged,
  });

  final void Function(Color) onColorChanged;

  @override
  State<UIColorPicker> createState() => _UIColorPickerState();
}

class _UIColorPickerState extends State<UIColorPicker> {
  final defaultColors = [
    Colors.white,
    Colors.white60,
    Colors.white38,
    Colors.brown,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.red
  ];

  List<Color> ownColors = List.empty(growable: true);
  List<Color> recentColors = List.empty(growable: true);

  bool newColor = false;
  Color currentColor = Colors.black;
  final int maxRecent = 16;

  @override
  Widget build(BuildContext context) {
    if (recentColors.length > maxRecent) {
      recentColors = recentColors.sublist(
          recentColors.length - maxRecent, recentColors.length);
    }

    final colorWheel = [
      ColorPicker(
        pickerColor: currentColor,
        paletteType: PaletteType.hsl,
        onColorChanged: (value) {
          currentColor = value;
        },
        colorHistory: defaultColors,
        enableAlpha: false,
        labelTypes: const [],
        pickerAreaBorderRadius:
            BorderRadius.all(const Radius.circular(UIConstants.cornerRadius)),
      ),
      UIButton(
        lable: "Save",
        onTap: () => setState(() {
          if (!recentColors.contains(currentColor))
            recentColors.add(currentColor);
          newColor = false;
          widget.onColorChanged(currentColor);
          ownColors.add(currentColor);
        }),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    ];

    final colorGrids = [
      Text(
        "Recent Colors",
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
              onPressed: () => widget.onColorChanged(recentColors[index]),
            );
          },
        ),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      Text(
        "Own Colors",
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
                  onPressed: () => setState(() => newColor = true),
                  icon: Icon(Icons.add));
            }
            return ColorButton(
              color: ownColors[index],
              onPressed: () {
                widget.onColorChanged(ownColors[index]);
                setState(() {
                  if (!recentColors.contains(ownColors[index]))
                    recentColors.add(ownColors[index]);
                });
              },
            );
          },
        ),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      Text(
        "Default Colors",
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: UIConstants.defaultSize),
      ColorGridView(
        children: List.generate(
          defaultColors.length,
          (index) {
            return ColorButton(
              color: defaultColors[index],
              onPressed: () {
                widget.onColorChanged(defaultColors[index]);
                setState(() {
                  if (!recentColors.contains(defaultColors[index]))
                    recentColors.add(defaultColors[index]);
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
        children: newColor ? colorWheel : colorGrids,
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
        children: children);
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
