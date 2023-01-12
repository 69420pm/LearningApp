import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/calendar/view/calendar_page.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/overview/view/overview_page.dart';
import 'package:learning_app/settings/view/settings_page.dart';
import 'package:ui_components/ui_components.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  /// index of current navbar status
  final PageController _pageController = PageController();
  int pageIndex = 0;
  final pages = <Widget>[
    const OverviewPage(),
    const CalendarPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeOverview) {
          pageIndex = 0;
        } else if (state is HomeCalendar) {
          pageIndex = 1;
        } else if (state is HomeSettings) {
          pageIndex = 2;
        } else {
          return const ErrorPage(errorMessage: 'Bottom navigation bar error');
        }

        return Scaffold(
          body: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (context, index) => pages[index],
            onPageChanged: (pageIndex) =>
                context.read<HomeCubit>().setTab(pageIndex),
          ),
          bottomNavigationBar: _BottomNavBar(
            navbarIndex: pageIndex,
            pageController: _pageController,
          ),
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.navbarIndex,
    required this.pageController,
  });

  final int navbarIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      /// when a navbar tile gets pressed
      onDestinationSelected: pageController.jumpToPage,
      height: UISizeConstants.defaultSize * 7,
      selectedIndex: navbarIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: const [
        /// Overview tile
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Overview',
        ),

        /// Calendar tile
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Calender',
        ),

        /// Settings tile
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
