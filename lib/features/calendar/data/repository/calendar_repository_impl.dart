import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/data/datasource/calendar_data_source.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/core/helper/state_compare.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';

class CalendarRepositoryImpl extends CalendarRepository {
  final CalendarDataSource lds;
  final CalendarDataSource rds;

  CalendarRepositoryImpl({
    required this.lds,
    required this.rds,
  });

  @override
  Future<Either<Failure, Calendar>> getCalendar() async {
    try {
      var rdsCal = await rds.getCalendar();
      var ldsCal = await lds.getCalendar();

      return right(
        StateCompare<CalendarModel?>().getNewestState(
          ldsCal,
          rdsCal,
          ldsCal?.changeDate,
          rdsCal?.changeDate,
          CalendarModel(changeDate: DateTime.now()),
        )!,
      );
    } catch (e) {
      return left(
        CalendarNotFoundFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveCalendar(Calendar calendar) async {
    try {
      await lds.saveCalendar(calendar.toModel());
      await rds.saveCalendar(calendar.toModel());

      return right(NoParams());
    } on Exception {
      return left(
        CalendarNotFoundFailure(
          errorMessage: "Calendar saving error",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteCalendar() async {
    try {
      return right(lds.deleteCalendar());
    } on Exception {
      return left(
        CalendarNotFoundFailure(
          errorMessage: "Calendar deletion error",
        ),
      );
    }
  }
}
