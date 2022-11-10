import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/overview/view/overview_page.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  /// index of current navbar status
  int navbarIndex = 0;

  final screens = [
    /// TODO remove place holder
    OverviewPage(),
    Center(
      child: Text("1234"),
    ),
    Center(
      child: Text("1235"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeOverview) {
          return const OverviewPage();
        } else if (state is HomeCalendar) {
          return const Scaffold(
            bottomNavigationBar: _BottomNavBar(
              navbarIndex: 1,
            ),
          );
        } else if (state is HomeSettings) {
          return const Scaffold(
            bottomNavigationBar: _BottomNavBar(
              navbarIndex: 2,
            ),
          );
        } else if (state is HomeCardReview) {
          return Scaffold();
          // navbarIndex = 1;
        }
        return const ErrorPage(errorMessage: 'Bottom navigation bar error');
      },
    );
    ;
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({super.key, required this.navbarIndex});

  final int navbarIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      /// when a navbar tile gets pressed
      onDestinationSelected: (value) {
        context.read<HomeCubit>().setTab(value);
      },
      selectedIndex: navbarIndex,
      destinations: [
        /// Overview tile
        const NavigationDestination(
            icon: const Icon(Icons.email_outlined), label: "Fuck you"),

        /// Calendar tile
        const NavigationDestination(
            icon: const Icon(Icons.email_outlined), label: "Fuck you"),

        /// Settings tile
        const NavigationDestination(
            icon: const Icon(Icons.email_outlined), label: "Fuck you"),
      ],
    );
  }
}
