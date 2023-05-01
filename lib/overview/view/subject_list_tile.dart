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
      padding: const EdgeInsets.only(top: UIConstants.defaultSize),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed('/subject_overview', arguments: subject),
        child: Container(
          height: UIConstants.defaultSize * 6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(
              Radius.circular(UIConstants.cornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultSize * 2,
              vertical: UIConstants.defaultSize,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                IconButton(
                  onPressed: () =>
                      context.read<AddSubjectCubit>().deleteSubject(subject.id),
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
