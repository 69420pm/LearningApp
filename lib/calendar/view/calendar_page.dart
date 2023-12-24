import 'package:flutter/material.dart';
import 'package:learning_app/calendar/view/calendar_widget.dart';
import 'package:learning_app/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/ui_components/widgets/ui_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UIPage(
      appBar: UIAppBar(
        title: 'Calendar',
        leadingBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [CalendarWidget()],
        ),
      ),
    );
  }
}
