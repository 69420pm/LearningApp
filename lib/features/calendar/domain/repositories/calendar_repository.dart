import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/calendar/data/models/streak_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streak.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';

abstract class CalendarRepository {
  Future<Either<Failure, void>> saveStreaks(Streaks streaks);
  Future<Either<Failure, Streaks>> getStreaks();
  Future<Either<Failure, void>> deleteStreaks();

  Either<Failure, Stream<Streaks?>> watchStreaks();
}
