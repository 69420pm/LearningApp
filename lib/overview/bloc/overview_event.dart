part of 'overview_bloc.dart';

@immutable
abstract class OverviewEvent {}

class OverviewSubjectSubscriptionRequested extends OverviewEvent {
  OverviewSubjectSubscriptionRequested();
}
