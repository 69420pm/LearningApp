import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/data/datasources/file_system_local_data_source.dart';
import 'package:learning_app/features/file_system/domain/helper/file_system_helper.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class GetParentId extends UseCase<String, String> {
  final FileSystemLocalDataSource dataSource;
  GetParentId({required this.dataSource});
  @override
  Future<Either<Failure, String>> call(String id) {
    return FileSystemHelper.getParentId(id, dataSource);
  }
}
