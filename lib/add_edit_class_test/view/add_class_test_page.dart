import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class AddClassTestPage extends StatelessWidget {
  AddClassTestPage(
      {super.key, required this.classTest}){
        addClassTest = classTest==null;
      }

  ClassTest? classTest;
  bool addClassTest = true;

  @override
  Widget build(BuildContext context) {
    return UIPage(
      appBar: UIAppBar(
        leading: UIIconButton(
          icon: UIIcons.arrowBack,
          onPressed: () {},
        ),
        actions: [UIIconButton(icon: UIIcons.share, onPressed: () {})],
        title: 'Subject Settings',
      ),
    );
  }
}
