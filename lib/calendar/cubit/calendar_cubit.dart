import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/calendar/view/day.dart';
import 'package:learning_app/calendar_backend/calendar_api/models/calendar_day.dart';
import 'package:learning_app/calendar_backend/calendar_repository.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required this.calendarRepository,
    required this.cardsRepository,
  }) : super(CalendarShowMonth(dateTime: DateTime.now()));

  CalendarRepository calendarRepository;
  CardsRepository cardsRepository;
  DateTime currentMonth = DateTime.now();

  Future<int> updateStreak() async {
    int streakLength = 0;
    final today =
        await calendarRepository.getCalendarDayByDate(DateTime.now()) ??
            CalendarDay(
              uid: Uid().uid(),
              date: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ),
              learnedCardsIds: const [],
              streakCompleted: false,
            );
    if (today.streakCompleted == true) {
      streakLength = 1;
    }
    streakLength =
        await _updateStreakRecursive(today.date.subtract(Duration(days: 1)), 0);
    emit(CalendarStreakChanged(streak: streakLength));
    return streakLength;
  }

  Future<int> _updateStreakRecursive(DateTime date, int streakLength) async {
    final calendarDay = await calendarRepository.getCalendarDayByDate(date);
    if (calendarDay != null && calendarDay.streakCompleted == true) {
      final newStreakLength = streakLength + 1;
      return _updateStreakRecursive(date, newStreakLength);
    }
    return streakLength;
  }

  Future<int> updateStreakSaver() async {
    int streakSaver = await calendarRepository.getStreakSaver();
    emit(CalendarStreakSaverChanged(streakSaver: streakSaver));
    return streakSaver;
  }

  Future<int> addStreakSaver(int numToAdd) async {
    int streakSaver = await calendarRepository.getStreakSaver();
    streakSaver = (streakSaver + numToAdd).clamp(0, 2);
    await calendarRepository.saveStreakSaver(streakSaver);
    emit(CalendarStreakSaverChanged(streakSaver: streakSaver));
    return streakSaver;
  }

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

  void changeClassTest(ClassTest classTest) {
    emit(CalendarClassTestChanged(classTest: classTest));
  }

  Future<void> saveCalendarDay(CalendarDay calendarDay) {
    return calendarRepository.saveCalendarDay(calendarDay);
  }

  Future<CalendarDay?> getCalendarDay(DateTime dateTime) {
    return calendarRepository.getCalendarDayByDate(dateTime);
  }

  Map<Subject, List<ClassTest>> getClassTests() {
    final subjects = cardsRepository.getSubjects().value.values.toList();
    final classTestMap = <Subject, List<ClassTest>>{};
    for (var subject in subjects) {
      classTestMap[subject] =
          cardsRepository.getClassTestsBySubjectId(subject.uid) ?? [];
    }
    return classTestMap;
  }

  Map<int, List<Subject>> getSubjectsMappedToWeekday() {
    final subjects = cardsRepository.getSubjects().value.values.toList();
    final subjectsToWeekday = <int, List<Subject>>{};
    for (final subject in subjects) {
      for (int i = 0; i < subject.scheduledDays.length; i++) {
        if (subject.scheduledDays[i] == true) {
          if (subjectsToWeekday[i+1] != null) {
            subjectsToWeekday[i + 1]!.add(subject);
          } else {
            subjectsToWeekday[i + 1] = [subject];
          }
        }
      }
    }
    return subjectsToWeekday;
  }

  List<ClassTest> getClassTestsByDate(DateTime dateTime) {
    return cardsRepository.getClassTestsByDate(
            DateTime(dateTime.year, dateTime.month, dateTime.day)) ??
        [];
  }
}
