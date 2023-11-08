import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';

class SubjectList extends StatelessWidget {
  SubjectList({super.key, this.showDisabled = false});

  /// if true show disabled, if false show only enabled subjects
  bool showDisabled;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          context.read<OverviewCubit>().cardsRepository.getSubjects(),
      builder: (context, box, _) {
        final subjects = box.values
            .toList()
            .cast<Subject>()
            .map((e) => SubjectListTile(subject: e))
            .toList();
        return Column(children: subjects);
      },
    );
  }
}
