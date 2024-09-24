import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:learning_app/features/subject/presentation/widgets/add_folder_bottom_sheet.dart';

class SubjectToolBar extends StatelessWidget {
  const SubjectToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyHeaderDelegate(
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          alignment: Alignment.center,
          child: UILabelRow(
            labelText: "Files",
            horizontalPadding: true,
            actionWidgets: [
              UIIconButton(
                text: "100 cards",
                swapTextWithIcon: true,
                icon: UIIcons.debug.copyWith(color: UIColors.overlay),
                onPressed: () {
                  final r = Random();
                  for (var i = 0; i < 100; i++) {
                    context.read<SubjectBloc>().add(SubjectCreateCard());
                  }
                },
              ),
              UIIconButton(
                icon: UIIcons.addFolder.copyWith(color: UIColors.smallText),
                onPressed: () {
                  UIBottomSheet.showUIBottomSheet(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<SubjectBloc>(),
                        child: BlocProvider.value(
                          value: context.read<SubjectSelectionCubit>(),
                          child: const AddFolderBottomSheet(),
                        ),
                      );
                    },
                  );
                },
              ),
              UIIconButton(
                alignment: Alignment.topRight,
                icon: UIIcons.card.copyWith(color: UIColors.smallText),
                onPressed: () {
                  context.read<SubjectBloc>().add(SubjectCreateCard());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate(this.child);
  final Widget child;

  @override
  double get minExtent => UIConstants.defaultSize * 6;

  @override
  double get maxExtent => UIConstants.defaultSize * 6;

  @override
  Widget build(BuildContext context, double __, bool _) => child;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
