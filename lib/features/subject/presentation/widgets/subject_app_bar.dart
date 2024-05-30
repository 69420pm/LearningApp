import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_app_bar_cubit.dart';

class SubjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubjectAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
    return BlocBuilder<SubjectAppBarCubit, SubjectAppBarState>(
      builder: (context, state) {
        switch (state) {
          case SubjectAppBarNothingSelected():
            return AppBar();
          case SubjectAppBarCardSelected():
            return AppBar();
          case SubjectAppBarFolderSelected():
            return AppBar();
          case SubjectAppBarFilesSelected():
            return AppBar();
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
