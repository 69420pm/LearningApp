import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:learning_app/features/calendar/domain/usecases/get_calendar.dart';
import 'package:learning_app/features/calendar/domain/usecases/save_calendar.dart';
import 'package:learning_app/generated/l10n.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(
      {required this.getCalendarUseCase, required this.saveCalendarUseCase})
      : super(CalendarInitial()) {
    _getCalendar();
  }

  final GetCalendar getCalendarUseCase;
  final SaveCalendar saveCalendarUseCase;

  Calendar _calendar = Calendar();
  Streaks get streaks => _calendar.streaks;
  int get streakSaver => _calendar.streakSaver;
  int get maxStreakSaver => _calendar.maxStreakSaver;

  Future<void> _getCalendar() async {
    emit(CalendarLoading());
    final calendarEither = await getCalendarUseCase(NoParams());
    calendarEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (calendar) {
        _calendar = calendar;
      },
    );
    emit(CalendarUpdated());
    _saveCalendar();
  }

  Future<void> addDayToStreaks(DateTime day) async {
    day = day.onlyDay();
    emit(CalendarLoading());
    if (_calendar.streakSaver > 0 &&
        !_calendar.streaks.contains(day) &&
        (day.isToday() || day.isBefore(DateTime.now()))) {
      _calendar.streaks.addDayToStreak(day);
      _calendar.streakSaver--;
      _calendar.updateChangeDate();
      _saveCalendar();
    }
  }

  Future<void> addStreakSaver() async {
    emit(CalendarLoading());
    if (_calendar.streakSaver < _calendar.maxStreakSaver) {
      _calendar.streakSaver++;
      _calendar.updateChangeDate();

      await _saveCalendar();
    }
  }

  Future<void> deleteStreaks() async {
    emit(CalendarLoading());
    _calendar.streaks.clear();
    _calendar.updateChangeDate();

    await _saveCalendar();
  }

  _saveCalendar() async {
    final streaksEither = await saveCalendarUseCase(_calendar);
    streaksEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (_) => emit(CalendarUpdated()),
    );
  }
}
