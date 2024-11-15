import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class GetCalendar implements UseCase<Calendar, NoParams> {
  final CalendarRepository repository;

  GetCalendar({
    required this.repository,
  });

  @override
  Future<Either<Failure, Calendar>> call(NoParams params) async {
    return await repository.getCalendar();
  }
}
