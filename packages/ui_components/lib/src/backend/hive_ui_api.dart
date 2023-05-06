import 'dart:ui';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_components/ui_components.dart';

class HiveUIApi extends UIApi {
  HiveUIApi(this._hiveBox);

  final Box<dynamic> _hiveBox;
  @override
  List<Color> getCustomColors() {
    try {
      final loadedColors = _hiveBox.get('custom_colors') as List<String>;
      return _colorsFromJson(loadedColors);
    } catch (e) {
      return [];
    }
  }

  @override
  List<Color> getRecentColors() {
    try {
      final loadedColors = _hiveBox.get('recent_colors') as List<String>;
      return _colorsFromJson(loadedColors);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveCustomColors(List<Color> colors) {
    return _hiveBox.put('custom_colors', _colorsToJson(colors));
  }

  @override
  Future<void> saveRecentColors(List<Color> colors) {
    return _hiveBox.put('recent_colors', _colorsToJson(colors));
  }

  List<String> _colorsToJson(List<Color> colors) {
    final jsonColors = <String>[];
    colors.forEach((element) {
      _Color color =
          _Color(element.alpha, element.red, element.green, element.blue);
      jsonColors.add(color.toJson());
    });
    return jsonColors;
  }

  List<Color> _colorsFromJson(List<String> jsons) {
    final colors = <Color>[];
    jsons.forEach((element) {
      _Color color = _Color.fromJson(element);
      colors.add(color.asColor());
    });
    return colors;
  }
}

class _Color {
  _Color(this.alpha, this.red, this.green, this.blue);
  int alpha;
  int red;
  int green;
  int blue;

  Color asColor() {
    return Color.fromARGB(alpha, red, green, blue);
  }

  factory _Color.fromMap(Map<String, dynamic> map) {
    return _Color(
      map['alpha'] as int,
      map['red'] as int,
      map['green'] as int,
      map['blue'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {'alpha': alpha, 'red': red, 'green': green, 'blue': blue};
  }

  String toJson() => json.encode(toMap());
  factory _Color.fromJson(String source) =>
      _Color.fromMap(json.decode(source) as Map<String, dynamic>);

  _Color copyWith({int? alpha, int? red, int? green, int? blue}) {
    return _Color(
      alpha ?? this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
