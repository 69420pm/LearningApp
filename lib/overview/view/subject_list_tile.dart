import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_components/ui_components.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: UISizeConstants.defaultSize),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed("/subject_overview", arguments: subject),
        child: Container(
            height: UISizeConstants.defaultSize * 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.all(
                  Radius.circular(UISizeConstants.cornerRadius)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: UISizeConstants.defaultSize * 2,
                  vertical: UISizeConstants.defaultSize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subject.name),
                  Icon(Icons.drag_indicator),
                ],
              ),
            )),
      ),
    );
  }
}
