import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/features/auth/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/subject_list.dart';
import 'package:learning_app/features/home/presentation/widgets/calendar_card.dart';
import 'package:learning_app/features/home/presentation/widgets/learn_all_card.dart';
import 'package:learning_app/features/home/presentation/widgets/subjects_tool_bar.dart';
import 'package:learning_app/generated/l10n.dart';
import 'package:learning_app/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<HomeBloc>()..add(HomeSubjectWatchChildrenIds()),
        ),
        BlocProvider(
          create: (context) => sl<CalendarCubit>(),
        ),
      ],
      child: const ResponsiveLayout(
        mobile: _HomeViewMobile(),
        desktop: null,
      ),
    );
  }
}

class _HomeViewMobile extends StatelessWidget {
  const _HomeViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(
        title: S
            .of(context)
            .homePageAppBar(FirebaseAuth.instance.currentUser!.email!),
        leadingBackButton: false,
        actions: [
          UIIconButton(
            icon: UIIcons.account,
            onPressed: () {
              context.read<AuthenticationBloc>().add(LoggedOut());
            },
          ),
        ],
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
              const SliverToBoxAdapter(
                  child: SizedBox(height: UIConstants.itemPadding)),
              const SubjectsToolBar(),
              const HomeSubjectList(),
            ],
          ),
        ),
      ),
    );
  }
}
