import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/calendar/data/models/streaks_model.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';

class GetStreaks implements UseCase<Streaks, NoParams> {
  final CalendarRepository repository;

  GetStreaks({
    required this.repository,
  });

  @override
  Future<Either<Failure, Streaks>> call(NoParams params) async {
    return await repository.getStreaks();
  }
}
