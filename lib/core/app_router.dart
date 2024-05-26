import 'package:go_router/go_router.dart';
import 'package:learning_app/features/subject/presentation/pages/subject_page.dart';
import 'package:learning_app/features/home/presentation/pages/home_page.dart';

final GoRouter router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return HomePage();
      },
      routes: [
        GoRoute(
          path: 'subject/:subjectId',
          name: 'subject',
          builder: (context, state) {
            return SubjectPage(subjectId: state.pathParameters['subjectId']!);
          },
        )
      ])
]);
