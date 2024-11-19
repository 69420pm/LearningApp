import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/calendar/data/models/time_span_model.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';

abstract class CalendarRepository {
  Future<Either<Failure, void>> saveCalendar(Calendar calendar);
  Future<Either<Failure, Calendar>> getCalendar();
  Future<Either<Failure, void>> deleteCalendar();
}
