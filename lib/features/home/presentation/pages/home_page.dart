import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/home_subject_list.dart';
import 'package:learning_app/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.test),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(context.namedLocation("editor"));

          // context
          //   .read<HomeBloc>()
          //   .add(const HomeSubjectAddSubject(name: "69"));
        },
      ),
      body: SafeArea(
        child: HomeSubjectList(),
      ),
    );
  }
}
