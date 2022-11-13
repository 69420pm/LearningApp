import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/overview/view/learn_all_button.dart';
import 'package:learning_app/overview/view/search_bar.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text(
              "Add Subject",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            heroTag: 'subject',
            onPressed: () => Navigator.of(context).pushNamed('/add_subject'),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          const SizedBox(
            height: UiSizeConstants.defaultSize,
          ),

          /// Add card FAB
          FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: Text("Add Card"),
            heroTag: 'card',
            onPressed: () => Navigator.of(context).pushNamed('/add_card'),
          ),

          /// Add subject FAB
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: UiSizeConstants.paddingEdge),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: UiSizeConstants.defaultSize * 1),
              const SearchBar(),
              const SizedBox(height: UiSizeConstants.defaultSize * 2),
              const LearnAllButton(),
              BlocBuilder<OverviewBloc, OverviewState>(
                  builder: (context, state) {
                if (state is OverviewSuccess) {
                  final subjectListTiles =
                      List<SubjectListTile>.empty(growable: true);
                  state.subjects.forEach(
                    (element) {
                      subjectListTiles.add(SubjectListTile(subject: element));
                    },
                  );
                  print(subjectListTiles);
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: subjectListTiles,
                  );
                }
                return Text("error");
              })
            ],
          ),
        ),
      ),
    );
  }
}
