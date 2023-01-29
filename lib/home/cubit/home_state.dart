part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

/// Overview page with FAB
class HomeOverview extends HomeState {}

/// Calendar page, where you can add class tests amd daily reminders
class HomeCalendar extends HomeState {}

/// General settings page
class HomeSettings extends HomeState {}
