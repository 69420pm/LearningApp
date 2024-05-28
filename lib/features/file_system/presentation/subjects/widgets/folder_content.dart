// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/injection_container.dart';

class FolderContent extends StatelessWidget {
  final String parentId;
  const FolderContent({
    super.key,
    required this.parentId,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return sl<FolderBloc>(param1: parentId)
          ..add(FolderWatchChildrenIds(parentId: parentId));
      },
      child: _FolderContent(
        parentId: parentId,
      ),
    );
  }
}

class _FolderContent extends StatelessWidget {
  const _FolderContent({super.key, required this.parentId});
  final String parentId;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (context, state) {
        switch (state) {
          case FolderLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case FolderError():
            return Text(state.errorMessage);
          case FolderSuccess():
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.ids.length,
              itemBuilder: (context, index) {
                return ListTileWrapper(id: state.ids[index]);
                // ..isHighlight = index.isOdd;
              },
            );
        }
      },
    );
  }
}
