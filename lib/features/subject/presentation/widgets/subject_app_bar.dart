import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

class SubjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubjectAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
      builder: (context, state) {
        bool inSelectionMode =
            context.read<SubjectSelectionCubit>().inSelectionMode;
        return UIAppBar(
          title: "subject.name",
          leading: inSelectionMode
              ? UIIconButton(
                  icon: UIIcons.close,
                  onPressed: () =>
                      context.read<SubjectSelectionCubit>().deselectAll(),
                )
              : null,
          actions: [
            UIIconButton(
              icon: UIIcons.settings,
              onPressed: () {},
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
