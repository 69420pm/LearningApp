import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/home/cubit/home_cubit.dart';
import 'package:learning_app/overview/view/overview_page.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  /// index of current navbar status
  int navbarIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

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
        int pageIndex = 0;
        List<Widget> pages = [
          OverviewPage(),
          Scaffold(
              appBar: AppBar(
            title: Text('Calender'),
          )),
          Scaffold(
              appBar: AppBar(
            title: Text('Settings'),
          ))
        ];
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
    ;
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar(
      {super.key, required this.navbarIndex, required this.pageController});

  final int navbarIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      /// when a navbar tile gets pressed
      onDestinationSelected: (value) {
        context.read<HomeCubit>().setTab(value);
        pageController.jumpToPage(value);
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
