import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/features/home/presentation/widgets/add_subject_bottom_sheet.dart';
import 'package:learning_app/generated/l10n.dart';

class SubjectsToolBar extends StatelessWidget {
  const SubjectsToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyToolBarHeaderDelegate(
        UILabelRow(
          labelText: S.of(context).subject(2),
          actionWidgets: [
            // UIIconButton(
            //   icon: UIIcons.download.copyWith(color: UIColors.smallText),
            //   onPressed: () {},
            // ),
            UIIconButton(
              icon: UIIcons.add.copyWith(color: UIColors.smallText),
              onPressed: () {
                UIBottomSheet.showUIBottomSheet(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<HomeBloc>(),
                      child: const AddSubjectBottomSheet(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
