import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/bloc/file_bloc.dart';
import 'package:learning_app/injection_container.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FileBloc>(param1: subjectId)
        ..add(FileWatchChildrenIds(parentId: subjectId)),
      child: const SubjectView(),
    );
  }
}

class SubjectView extends StatelessWidget {
  const SubjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<FileBloc>().add(FileCreateFolder(name: "name")),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<FileBloc, FileState>(
              builder: (context, state) {
                switch (state) {
                  case FileLoading():
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case FileError():
                    return Text(state.errorMessage);
                  case FileSuccess():
                    return CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.ids.length,
                            (context, index) {
                              return Text(state.ids[index].id);
                            },
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
