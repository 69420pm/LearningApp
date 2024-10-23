// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
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
    this.changeExtensionState = false,
  });

  final Folder folder;
  final void Function() onTap;
  final bool isSelected;
  final bool isHovered;
  final bool changeExtensionState;
  @override
  Widget build(BuildContext context) {
    return FolderDragTarget(
      folderId: folder.id,
      child: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.defaultSize),
        child: GestureDetector(
          onTap: onTap,
          child: UIExpansionTile(
            iconSize: UIConstants.defaultSize * 3,
            changeExtensionState: changeExtensionState,
            backgroundColor: isHovered
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainer,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: UIConstants.borderWidth,
            ),
            title: folder.name,
            collapsedHeight: UIConstants.defaultSize * 8,
            //trailing: UILinearProgressIndicator(value: 0.5),
            child: FolderContent(parentId: folder.id),
          ),
        ),
      ),
    );
  }
}
