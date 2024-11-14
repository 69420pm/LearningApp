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
      : super(CalendarInitial());

  final GetCalendar getCalendarUseCase;
  final SaveCalendar saveCalendarUseCase;

  Calendar _calendar = Calendar();
  Streaks get streaks => _calendar.streaks;
  int get streakSaver => _calendar.streakSaver;
  int get maxStreakSaver => _calendar.maxStreakSaver;

  Future<void> getCalendar() async {
    emit(CalendarLoading());
    final calendarEither = await getCalendarUseCase(NoParams());
    calendarEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (calendar) {
        _calendar = calendar;
      },
    );
    emit(CalendarLoaded());
  }

  Future<void> addDayToStreaks(DateTime day) async {
    emit(CalendarLoading());
    if (_calendar.streakSaver > 0) {
      _calendar.streaks.addDayToStreak(day);
      _calendar.streakSaver--;
    }

    final streaksEither = await saveCalendarUseCase(_calendar);
    streaksEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (_) => emit(CalendarSaved()),
    );
  }

  Future<void> addStreakSaver() async {
    emit(CalendarLoading());
    if (_calendar.streakSaver < _calendar.maxStreakSaver) {
      _calendar.streakSaver++;
    }

    final streaksEither = await saveCalendarUseCase(_calendar);
    streaksEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (_) => emit(CalendarSaved()),
    );
  }

  Future<void> deleteStreaks() async {
    emit(CalendarLoading());
    _calendar.streaks.clear();
    final streaksEither = await saveCalendarUseCase(_calendar);
    streaksEither.fold(
      (failure) => emit(CalendarError(errorMessage: failure.errorMessage)),
      (_) => emit(CalendarLoaded()),
    );
    await getCalendar();
  }
}
