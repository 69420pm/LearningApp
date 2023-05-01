import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ui_components/src/ui_size_constants.dart';

class UIColorPicker extends StatelessWidget {
  UIColorPicker({super.key, required this.onColorChanged});
  ValueChanged<Color> onColorChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorPicker(
          pickerColor: Colors.black,
          paletteType: PaletteType.hsl,
          onColorChanged: (value) => onColorChanged.call(value),
          enableAlpha: false,
          labelTypes: const [],
          pickerAreaBorderRadius: BorderRadius.all(
              const Radius.circular(UISizeConstants.cornerRadius)),
        ),
        Row(
          children: [
            _ColorField(
              color: Colors.white,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.white60,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.white38,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.brown,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.orange,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.yellow,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.green,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.blue,
              onColorChanged: onColorChanged,
            ),
            _ColorField(
              color: Colors.purple,
              onColorChanged: onColorChanged,
            ),_ColorField(
              color: Colors.pink,
              onColorChanged: onColorChanged,
            ),_ColorField(
              color: Colors.red,
              onColorChanged: onColorChanged,
            ),
          ],
        )
      ],
    );
  }
}

class _ColorField extends StatelessWidget {
  _ColorField({super.key, required this.color, required this.onColorChanged});
  Color color;
  ValueChanged<Color> onColorChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: GestureDetector(
        onTap: () => onColorChanged.call(color),
        child: Container(height: 40, width: 35, color: color),
      ),
    );
  }
}
