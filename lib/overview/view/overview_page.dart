import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';
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
            icon: const Icon(Icons.add),
            label: Text(
              'Add Subject',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            heroTag: 'subject',
            onPressed: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => BlocProvider.value(
                      value: context.read<AddSubjectCubit>(),
                      child: AddSubjectBottomSheet(),
                    ),),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          const SizedBox(
            height: UISizeConstants.defaultSize,
          ),

          ///* Add card FAB deprecated
          // FloatingActionButton.extended(
          //   icon: const Icon(Icons.add),
          //   label: Text("Add Card"),
          //   heroTag: 'card',
          //   onPressed: () => Navigator.of(context).pushNamed('/add_card'),
          // ),

          /// Add subject FAB
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: UISizeConstants.paddingEdge),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: UISizeConstants.defaultSize * 1),
              const SearchBar(),
              const SizedBox(height: UISizeConstants.defaultSize * 2),
              const LearnAllButton(),
              BlocBuilder<OverviewBloc, OverviewState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state is OverviewSuccess) {
                      return ListView.builder(
                        itemCount: state.subjects.length,
                        itemBuilder: (context, index) =>
                            SubjectListTile(subject: state.subjects[index]),
                        shrinkWrap: true,
                      );
                    } else if (state is OverviewLoading) {
                      // TODO add loading placeholder
                    }
                    return Text("error");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
