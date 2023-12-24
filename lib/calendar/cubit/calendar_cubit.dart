import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';
import 'package:learning_app/calendar_backend/calendar_repository.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required this.calendarRepository, required this.cardsRepository})
      : super(CalendarShowMonth(dateTime: DateTime.now()));

  CalendarRepository calendarRepository;
  CardsRepository cardsRepository;
  DateTime currentMonth = DateTime.now();

  void changeMonthUp() {
    if (currentMonth.month < 12) {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    } else {
      currentMonth = DateTime(currentMonth.year + 1);
    }
    emit(CalendarShowMonth(dateTime: currentMonth));
  }

  void changeMonthDown() {
    if (currentMonth.month > 1) {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    } else {
      currentMonth = DateTime(currentMonth.year - 1, 12);
    }
    emit(CalendarShowMonth(dateTime: currentMonth));
  }

  Future<void> saveCalendarDay(CalendarDay calendarDay) {
    return calendarRepository.saveCalendarDay(calendarDay);
  }

  Future<CalendarDay?> getCalendarDay(DateTime dateTime) async {
    return await calendarRepository.getCalendarDayByDate(dateTime);
  }

  List<ClassTest> getClassTests() {
    final classTests = <ClassTest>[];
    final subjects = cardsRepository.getSubjects().value.values.toList();
    for (final element in subjects) {
      classTests.addAll(element.classTests);
    }
    return classTests;
  }
}
