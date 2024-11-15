import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_app/core/helper/image_helper.dart';
import 'package:learning_app/features/calendar/data/datasource/calendar_local_data_source.dart';
import 'package:learning_app/features/calendar/data/repository/calendar_repository_impl.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:learning_app/features/calendar/domain/usecases/get_calendar.dart';
import 'package:learning_app/features/calendar/domain/usecases/save_calendar.dart';
import 'package:learning_app/features/calendar/domain/usecases/watch_calendar.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:learning_app/features/file_system/data/datasources/file_system_local_data_source.dart';
import 'package:learning_app/features/file_system/data/repositories/file_system_repository_impl.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';
import 'package:learning_app/features/file_system/domain/usecases/block_children_selection.dart';
import 'package:learning_app/features/file_system/domain/usecases/create_card.dart';
import 'package:learning_app/features/file_system/domain/usecases/create_folder.dart';
import 'package:learning_app/features/file_system/domain/usecases/create_subject.dart';
import 'package:learning_app/features/file_system/domain/usecases/delete_file.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parent_ids.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parentid.dart';
import 'package:learning_app/features/file_system/domain/usecases/move_file.dart';
import 'package:learning_app/features/file_system/domain/usecases/watch_children_file_system.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_file.dart';
import 'package:learning_app/features/file_system/domain/usecases/save_file.dart';
import 'package:learning_app/features/file_system/domain/usecases/watch_file.dart';
import 'package:learning_app/features/file_system/presentation/subjects/bloc/folder_bloc.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await external();
  features();
  core();
}

void features() {
  // File System
  // Bloc
  sl.registerFactory(
    () => HomeBloc(
      watchChildrenFileSystem: sl(),
      createSubject: sl(),
      watchFile: sl(),
    ),
  );
  sl.registerFactoryParam(
    (parentId, _) => FolderBloc(
      parentId: parentId as String,
      watchChildren: sl(),
      watchFile: sl(),
    ),
  );
  sl.registerFactoryParam(
    (subjectId, _) => SubjectBloc(
      createFolderUseCase: sl(),
      cerateCardUseCase: sl(),
      subjectId: subjectId as String,
      moveFileUseCase: sl(),
      getParentIdsUseCase: sl(),
      getFileUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => SubjectSelectionCubit(
      getRelationUseCase: sl(),
      getParentIdUseCase: sl(),
    ),
  );

  sl.registerFactory(() => EditorCubit());
  sl.registerFactory(() => SubjectHoverCubit());

  sl.registerFactoryParam(
    (parentId, _) => CalendarCubit(
      getCalendarUseCase: sl(),
      saveCalendarUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => WatchChildrenFileSystem(repository: sl()));
  sl.registerLazySingleton(() => GetFile(repository: sl()));
  sl.registerLazySingleton(() => SaveFile(repository: sl()));
  sl.registerLazySingleton(() => DeleteFile(repository: sl()));
  sl.registerLazySingleton(() => CreateSubject(repository: sl()));
  sl.registerLazySingleton(() => WatchFile(repository: sl()));
  sl.registerLazySingleton(() => CreateFolder(repository: sl()));
  sl.registerLazySingleton(() => CreateCard(repository: sl()));
  sl.registerLazySingleton(() => MoveFiles(repository: sl()));
  sl.registerLazySingleton(() => GetRelations(repository: sl()));
  sl.registerLazySingleton(() => GetParentId(dataSource: sl()));
  sl.registerLazySingleton(() => GetParentIds(dataSource: sl()));

  // Calendar
  sl.registerLazySingleton(() => GetCalendar(repository: sl()));
  sl.registerLazySingleton(() => SaveCalendar(repository: sl()));
  sl.registerLazySingleton(() => WatchCalendar(repository: sl()));

  // Repository
  sl.registerLazySingleton<FileSystemRepository>(
    () => FileSystemRepositoryImpl(lds: sl()),
  );
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(lds: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FileSystemLocalDataSource>(
    () => FileSystemHive(
      cardBox: sl(instanceName: "cardBox"),
      folderBox: sl(instanceName: "folderBox"),
      subjectBox: sl(instanceName: "subjectBox"),
      classTestBox: sl(instanceName: "classTestBox"),
      relationBox: sl(instanceName: "relationsBox"),
      classTestRelationBox: sl(instanceName: "classTestRelationsBox"),
    ),
  );
  sl.registerLazySingleton<CalendarLocalDataSource>(
    () => CalendarHive(
      calendarBox: sl(instanceName: "calendarBox"),
    ),
  );

  // Editor
  sl.registerFactory(() => ImagePicker());
  sl.registerFactory(() => ImageCropper());
  sl.registerFactory(() => ImageHelper(imagePicker: sl(), imageCropper: sl()));
}

void core() {}

Future<void> external() async {
  await Hive.initFlutter();

  final cardBox = await Hive.openBox<String>("cardBox");
  final folderBox = await Hive.openBox<String>("folderBox");
  final subjectBox = await Hive.openBox<String>("subjectBox");
  final classTestBox = await Hive.openBox<String>("classTestBox");
  final relationBox = await Hive.openBox<List<String>>("relationsBox");
  final classTestRelationBox =
      await Hive.openBox<List<String>>("classTestRelationBox");
  final streakBox = await Hive.openBox<String>("calendarBox");

  sl.registerLazySingleton(() => cardBox, instanceName: "cardBox");
  sl.registerLazySingleton(() => folderBox, instanceName: "folderBox");
  sl.registerLazySingleton(() => subjectBox, instanceName: "subjectBox");
  sl.registerLazySingleton(() => classTestBox, instanceName: "classTestBox");
  sl.registerLazySingleton(() => relationBox, instanceName: "relationsBox");
  sl.registerLazySingleton(() => classTestRelationBox,
      instanceName: "classTestRelationsBox");
  sl.registerLazySingleton(() => streakBox, instanceName: "calendarBox");
}
