import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green ,child: Text(subject.name));
  }
}