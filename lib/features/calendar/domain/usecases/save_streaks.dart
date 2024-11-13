import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class SaveStreaks implements UseCase<void, Streaks> {
  final CalendarRepository repository;

  SaveStreaks({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(Streaks params) async {
    return await repository.saveStreaks(params);
  }
}
