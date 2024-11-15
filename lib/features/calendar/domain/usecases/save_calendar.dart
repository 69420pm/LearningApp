import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/domain/entities/calendar.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class SaveCalendar implements UseCase<void, Calendar> {
  final CalendarRepository repository;

  SaveCalendar({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(Calendar params) async {
    return await repository.saveCalendar(params);
  }
}
