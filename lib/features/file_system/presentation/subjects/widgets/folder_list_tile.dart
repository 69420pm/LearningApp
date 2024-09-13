// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_expansion_tile.dart';
import 'package:learning_app/core/ui_components/ui_expansion_tilee.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';

import 'package:learning_app/features/file_system/presentation/subjects/interfaces/file_list_tile.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_content.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_drag_target.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';

class FolderListTile extends StatelessWidget implements FileListTile {
  const FolderListTile({
    super.key,
    required this.folder,
    required this.onTap,
    required this.isSelected,
    required this.isHovered,
  });

  final Folder folder;
  final void Function() onTap;
  final bool isSelected;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return FolderDragTarget(
      folderId: folder.id,
      child: GestureDetector(
        onTap: onTap,
        child: UIExpansionTile(
          startOpen: true,
          title: folder.id,
          backgroundColor: isHovered
              ? Colors.grey
              : isSelected
                  ? Colors.green
                  : Colors.black,
          child: FolderContent(parentId: folder.id),
        ),
      ),
    );
  }
}
