part of 'add_edit_class_test_cubit.dart';

sealed class AddEditClassTestState extends Equatable {
  const AddEditClassTestState();

  @override
  List<Object> get props => [];
}

final class AddEditClassTestInitial extends AddEditClassTestState {
  ClassTest? classTest;
  AddEditClassTestInitial({this.classTest});
}

final class AddEditClassTestChangedDate extends AddEditClassTestState {
  DateTime date;
  AddEditClassTestChangedDate({required this.date});

  @override
  List<Object> get props => [date.day, date.month, date.year];
}

final class AddEditClassTestChangedCanSave extends AddEditClassTestState {
  bool canSave;
  AddEditClassTestChangedCanSave({required this.canSave});
  @override
  List<Object> get props => [canSave];
}

final class AddEditClassTestChangedRelevantCards
    extends AddEditClassTestState {
  int relevantCardsLength;
  AddEditClassTestChangedRelevantCards({required this.relevantCardsLength});

  @override
  List<Object> get props => [relevantCardsLength];
}
