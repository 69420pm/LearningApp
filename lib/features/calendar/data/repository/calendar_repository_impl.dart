import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/calendar/data/datasource/calendar_local_data_source.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl extends CalendarRepository {
  final CalendarLocalDataSource lds;

  CalendarRepositoryImpl({
    required this.lds,
  });

  @override
  Future<Either<Failure, Streaks>> getStreaks() async {
    try {
      return right(await lds.getStreaks());
    } on Exception {
      return left(
        StreakNotFoundFailure(
          errorMessage: "Streaks not found",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveStreaks(Streaks streaks) async {
    try {
      return right(lds.saveStreaks(streaks.toModel()));
    } on Exception {
      return left(
        StreakNotFoundFailure(
          errorMessage: "Streaks not found",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteStreaks() async {
    try {
      return right(lds.deleteStreaks());
    } on Exception {
      return left(
        StreakNotFoundFailure(
          errorMessage: "Streaks not found",
        ),
      );
    }
  }

  @override
  Either<Failure, Stream<Streaks?>> watchStreaks() {
    try {
      return right(lds.watchStreaks() as Stream<Streaks?>);
    } on Exception {
      return left(
        StreakNotFoundFailure(
          errorMessage: "Streaks not found",
        ),
      );
    }
  }
}
