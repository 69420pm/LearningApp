import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/view/add_card_page.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_folder/cubit/add_folder_cubit.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/add_subject/view/add_subject_bottom_sheet.dart';

import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/home/view/home_page.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_screen.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/view/subject_overview_page.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository);

  final CardsRepository _cardsRepository;

  final HomeCubit _homeCubit = HomeCubit();
  late final AddSubjectCubit _addSubjectCubit =
      AddSubjectCubit(_cardsRepository);
  late final AddFolderCubit _addFolderCubit = AddFolderCubit(_cardsRepository);
  late final EditSubjectBloc _editSubjectBloc =
      EditSubjectBloc(_cardsRepository);
  late final AddCardCubit _addCardCubit = AddCardCubit(_cardsRepository);
  late final OverviewBloc _overviewBloc = OverviewBloc(_cardsRepository)
    ..add(OverviewSubjectSubscriptionRequested());
  late final LearnCubit _learnCubit = LearnCubit();

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(
                value: _overviewBloc,
              ),
            ],
            child: HomePage(),
          ),
        );
      case '/add_card':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              BlocProvider.value(value: _addCardCubit),
              BlocProvider.value(value: _editSubjectBloc),
            ],
            child: AddCardPage(parentId: routeSettings.arguments as String),
          ),
        );
      // case '/add_subject':
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider.value(
      //           value: _homeCubit,
      //         ),
      //         BlocProvider.value(
      //           value: _addSubjectCubit,
      //         ),
      //       ],
      //       child: AddSubjectPage(
      //         recommendedSubjectParentId: routeSettings.arguments as String?,
      //       ),
      //     ),
      //   );

      case '/subject_overview':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _homeCubit,
              ),
              // BlocProvider.value(
              //   value: _editSubjectBloc,
              // ),
              BlocProvider(
                  create: ((context) => EditSubjectBloc(_cardsRepository))),
              BlocProvider.value(
                value: _addFolderCubit,
              )
            ],
            child: SubjectOverviewPage(
              subjectToEdit: routeSettings.arguments! as Subject,
            ),
          ),
        );

      case '/learn':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _learnCubit,
              ),
            ],
            child: LearningScreen(),
          ),
        );
      // error route
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorPage(
            errorMessage: 'Internal routing error',
          ),
        );
    }
  }
}
