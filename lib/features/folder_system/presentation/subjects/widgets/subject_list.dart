import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app_clone/features/folder_system/presentation/subjects/widgets/subject_list_tile.dart';
import 'package:learning_app_clone/features/home/presentation/bloc/home_bloc.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state) {
          case HomeLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case HomeError():
            return const Center(
              child: Text("error"),
            );
          case HomeSuccess():
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: state.subjectIds.length, (context, index) {
                    return SubjectListTile(
                      subjectId: state.subjectIds[index],
                    );
                  }),
                ),
              ],
            );
        }
      },
    );
  }
}
