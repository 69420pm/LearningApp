import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class WatchCalendar extends UseCase<Stream<Calendar?>, NoParams> {
  final CalendarRepository repository;

  WatchCalendar({required this.repository});

  @override
  Future<Either<Failure, Stream<Calendar?>>> call(NoParams params) async {
    return await repository.watchCalendar();
  }
}
