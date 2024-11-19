import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/calendar/data/datasource/calendar_local_data_source.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:learning_app/features/calendar/data/models/calendar_model.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';

class CalendarRepositoryImpl extends CalendarRepository {
  final CalendarLocalDataSource lds;

  CalendarRepositoryImpl({
    required this.lds,
  });

  @override
  Future<Either<Failure, Calendar>> getCalendar() async {
    try {
      return right(await lds.getCalendar());
    } on Exception {
      return left(
        CalendarNotFoundFailure(
          errorMessage: "Calendar not found",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveCalendar(Calendar calendar) async {
    try {
      return right(lds.saveCalendar(calendar.toModel()));
    } on Exception {
      return left(
        CalendarNotFoundFailure(
          errorMessage: "Calendar not found",
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
          errorMessage: "Calendar not found",
        ),
      );
    }
  }
}
