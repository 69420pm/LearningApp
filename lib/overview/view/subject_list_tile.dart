import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:ui_components/ui_components.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: UISizeConstants.defaultSize),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed('/subject_overview', arguments: subject),
        child: Container(
          height: UISizeConstants.defaultSize * 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(
              Radius.circular(UISizeConstants.cornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UISizeConstants.defaultSize * 2,
              vertical: UISizeConstants.defaultSize,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subject.name),
                const Icon(Icons.drag_indicator),
                IconButton(
                    onPressed: () => context
                        .read<AddSubjectCubit>()
                        .deleteSubject(subject.id),
                    icon: const Icon(Icons.abc),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
