import 'dart:ui';

import 'package:learning_app/ui_components/backend/ui_api.dart';


class UIRepository{
  const UIRepository({required UIApi uiApi}) : _uiApi = uiApi;
  final UIApi _uiApi;

  void saveCustomColors(List<Color> colors) => _uiApi.saveCustomColors(colors);

  void saveRecentColors(List<Color> colors) => _uiApi.saveRecentColors(colors);

  List<Color> getCustomColors() => _uiApi.getCustomColors();

  List<Color> getRecentColors() => _uiApi.getRecentColors();
}
