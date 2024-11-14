import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class WatchStreaks extends UseCase<Stream<Streaks?>, NoParams> {
  final CalendarRepository repository;

  WatchStreaks({required this.repository});

  @override
  Future<Either<Failure, Stream<Streaks?>>> call(NoParams params) async {
    return await repository.watchStreaks();
  }
}
