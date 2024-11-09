import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/subject_list.dart';
import 'package:learning_app/features/home/presentation/widgets/calendar_card.dart';
import 'package:learning_app/features/home/presentation/widgets/learn_all_card.dart';
import 'package:learning_app/features/home/presentation/widgets/subjects_tool_bar.dart';
import 'package:learning_app/features/subject/presentation/widgets/files_tool_bar.dart';
import 'package:learning_app/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(HomeSubjectWatchChildrenIds()),
      child: const ResponsiveLayout(
        mobile: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(
        title: AppLocalizations.of(context)!.test,
        leadingBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(context.namedLocation("editor"));
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.pageHorizontalPadding),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const LearnAllCard(),
                    const SizedBox(
                      height: UIConstants.itemPaddingLarge,
                    ),
                    const CalendarCard(),
                  ],
                ),
              ),
              const SubjectsToolBar(),
              const HomeSubjectList(),
            ],
          ),
        ),
      ),
    );
  }
}
