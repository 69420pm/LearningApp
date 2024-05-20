// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/features/folder_system/presentation/subjects/bloc/subject_bloc.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/widgets/folder_content.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<SubjectBloc>().add(SubjectCreateFolder(name: "name")),
      ),
      body: SafeArea(
        child: Column(
          children: [FolderContent(parentId: subjectId)],
        ),
      ),
    );
  }
}
