import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app_clone/features/folder_system/presentation/subjects/bloc/subject_bloc.dart';
import 'package:learning_app_clone/injection_container.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SubjectBloc>(param1: subjectId)
        ..add(SubjectWatchChildrenIds(parentId: subjectId)),
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
            context.read<SubjectBloc>().add(SubjectCreateFolder(name: "name")),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<SubjectBloc, SubjectState>(
              builder: (context, state) {
                switch (state) {
                  case SubjectLoading():
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case SubjectError():
                    return Text(state.errorMessage);
                  case SubjectSuccess():
                    return CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.ids.length,
                            (context, index) {
                              return Text(state.ids[index]);
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
