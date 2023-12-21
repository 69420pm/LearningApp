import 'dart:ui';

abstract class UIApi {
  const UIApi();

  void saveCustomColors(List<Color> colors);

  void saveRecentColors(List<Color> colors);

  List<Color> getCustomColors();

  List<Color> getRecentColors();
}
