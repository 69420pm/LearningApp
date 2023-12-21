import 'dart:ui';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:learning_app/ui_components/backend/ui_api.dart';

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
    for (final element in colors) {
      final color =
          _Color(element.alpha, element.red, element.green, element.blue);
      jsonColors.add(color.toJson());
    }
    return jsonColors;
  }

  List<Color> _colorsFromJson(List<String> jsons) {
    final colors = <Color>[];
    for (final element in jsons) {
      final color = _Color.fromJson(element);
      colors.add(color.asColor());
    }
    return colors;
  }
}

class _Color {
  _Color(this.alpha, this.red, this.green, this.blue);

  factory _Color.fromMap(Map<String, dynamic> map) {
    return _Color(
      map['alpha'] as int,
      map['red'] as int,
      map['green'] as int,
      map['blue'] as int,
    );
  }
  factory _Color.fromJson(String source) =>
      _Color.fromMap(json.decode(source) as Map<String, dynamic>);
  int alpha;
  int red;
  int green;
  int blue;

  Color asColor() {
    return Color.fromARGB(alpha, red, green, blue);
  }

  Map<String, dynamic> toMap() {
    return {'alpha': alpha, 'red': red, 'green': green, 'blue': blue};
  }

  String toJson() => json.encode(toMap());

  _Color copyWith({int? alpha, int? red, int? green, int? blue}) {
    return _Color(
      alpha ?? this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
