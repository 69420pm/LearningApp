import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app_clone/features/folder_system/presentation/subjects/widgets/subject_list.dart';
import 'package:learning_app_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app_clone/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(HomeSubjectWatchChildrenIds()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context
            .read<HomeBloc>()
            .add(const HomeSubjectAddSubject(name: "69")),
      ),
      body: const SafeArea(
        child: SubjectList(),
      ),
    );
  }
}
