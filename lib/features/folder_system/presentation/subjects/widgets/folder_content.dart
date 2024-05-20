// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/features/folder_system/presentation/subjects/bloc/file_bloc.dart';
import 'package:learning_app/features/folder_system/presentation/subjects/widgets/list_tile_wrapper.dart';
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
        return sl<FileBloc>(param1: parentId)
          ..add(FileWatchChildrenIds(parentId: parentId));
      },
      child: const _FolderContent(),
    );
  }
}

class _FolderContent extends StatelessWidget {
  const _FolderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        switch (state) {
          case FileLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case FileError():
            return Text(state.errorMessage);
          case FileSuccess():
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
