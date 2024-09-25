import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/subject_list_tile.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';

class HomeSubjectList extends StatelessWidget {
  const HomeSubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state) {
          case HomeLoading():
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeError():
            return SliverToBoxAdapter(
              child: Center(
                child: Text(state.errorMessage),
              ),
            );
          case HomeSuccess():
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: state.subjectIds.length, (context, index) {
                return SubjectListTile(
                  subjectId: state.subjectIds[index],
                );
              }),
            );
        }
      },
    );
  }
}
