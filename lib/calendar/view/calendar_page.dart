import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UIAppBar(
      title: Text('Calender'),
    ));
  }
}
