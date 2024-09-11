// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_content.dart';
import 'package:learning_app/features/subject/presentation/widgets/subject_app_bar.dart';
import 'package:learning_app/injection_container.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SubjectBloc>(param1: subjectId),
        ),
        BlocProvider(
          create: (context) => sl<SubjectSelectionCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SubjectHoverCubit>(),
        ),
      ],
      child: SubjectView(subjectId: subjectId),
    );
  }
}

class SubjectView extends StatelessWidget {
  final String subjectId;
  const SubjectView({
    super.key,
    required this.subjectId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubjectAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context
            .read<SubjectBloc>()
            .add(SubjectCreateFolder(name: DateTime.now().toIso8601String())),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FolderContent(parentId: subjectId),
            DragTarget(
              onMove: (details) {
                context.read<SubjectHoverCubit>().changeHover(subjectId);
              },
              onAcceptWithDetails:
                  (DragTargetDetails<FileDragDetails> details) {
                if (!context.read<SubjectSelectionCubit>().inSelectionMode &&
                    details.data.parentId == subjectId) {
                  print("sele");
                  //select file
                  context
                      .read<SubjectSelectionCubit>()
                      .changeSelection(details.data.fileId);
                } else {
                  //move hole selection to this folder
                  List<String> selectedIds =
                      context.read<SubjectSelectionCubit>().selectedIds;

                  if (!selectedIds.contains(details.data.fileId)) {
                    selectedIds.add(details.data.fileId);
                  }

                  context.read<SubjectBloc>().add(SubjectMoveFiles(
                      parentId: subjectId, fileIds: selectedIds));
                }
              },
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return Container(
                  color: Colors.blue,
                  height: 50,
                  width: double.infinity,
                  child: UIIconButton(
                    icon: UIIcons.add,
                    onPressed: () =>
                        context.read<SubjectBloc>().add(SubjectCreateCard()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
