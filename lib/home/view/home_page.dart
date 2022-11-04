import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/overview/view/overview_page.dart';

/// First page after Material App, responsible for Scaffold
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Inject HomeCubit(), which handles navigation navigation bar
  /// and main Scaffold
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

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
          navbarIndex = 0;
        } else if (state is HomeCalendar) {
          navbarIndex = 1;
        } else if (state is HomeSettings) {
          navbarIndex = 2;
        } else if (state is HomeCardReview) {
          // navbarIndex = 1;
        }
        return Scaffold(
            bottomNavigationBar: NavigationBar(
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
            ),
            body: SafeArea(child: screens[navbarIndex]));
      },
    );
    ;
  }
}
