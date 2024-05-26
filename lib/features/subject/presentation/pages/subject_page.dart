// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';

import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_content.dart';
import 'package:learning_app/injection_container.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SubjectBloc>(param1: subjectId),
      child: SubjectView(subjectId: subjectId),
    );
  }
}

class SubjectView extends StatelessWidget {
  final String subjectId;
  const SubjectView({
    super.key,
    required this.subjectId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context
            .read<SubjectBloc>()
            .add(SubjectCreateFolder(name: DateTime.now().toIso8601String())),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FolderContent(parentId: subjectId),
            UIIconButton(
              icon: UIIcons.add,
              onPressed: () =>
                  context.read<SubjectBloc>().add(SubjectCreateCard()),
            ),
          ],
        ),
      ),
    );
  }
}
