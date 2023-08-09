import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/overview/view/subject_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is OverviewSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.subjects.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                  top: index != 0 ? UIConstants.itemPadding / 2 : 0,
                  bottom: index != state.subjects.length - 1
                      ? UIConstants.itemPadding / 2
                      : 0),
              child: SubjectListTile(subject: state.subjects[index]),
            ),
          );
        } else if (state is OverviewLoading) {
          // TODO add loading placeholder
        }
        return const Text('error');
      },
    );
  }
}
