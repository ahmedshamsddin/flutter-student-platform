import 'package:get_it/get_it.dart';
import 'package:student_platform/core/api/api_service.dart';
import 'package:student_platform/features/student/lesson/data/datasources/lesson_remote_datasource.dart';
import 'package:student_platform/features/student/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:student_platform/features/student/lesson/domain/usecases/get_lessons_for_student.dart';
import 'package:student_platform/features/student/lesson/domain/repositories/lesson_repository.dart';
import 'package:student_platform/features/student/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:student_platform/features/student/exercise/data/datasources/exercise_remote_datasource.dart';
import 'package:student_platform/features/student/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:student_platform/features/student/exercise/domain/usecases/get_exercises_for_lesson.dart';
import 'package:student_platform/features/student/exercise/domain/repositories/exercise_repository.dart';
import 'package:student_platform/features/student/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:student_platform/features/student/solve/data/datasources/question_remote_datasource.dart';
import 'package:student_platform/features/student/solve/data/repositories/question_repository_impl.dart';
import 'package:student_platform/features/student/solve/domain/usecases/get_questions_for_exercise.dart';
import 'package:student_platform/features/student/solve/domain/repositories/question_repository.dart';
import 'package:student_platform/features/student/solve/presentation/bloc/exercise_solver_bloc.dart';
import 'package:student_platform/features/student/solve/data/services/attempt_service.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:student_platform/features/admin/archive/archive_exercise_cubit.dart';
import 'package:student_platform/features/admin/archive/archive_question_cubit.dart';
import 'package:student_platform/features/admin/lesson/data/datasources/admin_lesson_remote_datasource.dart';
import 'package:student_platform/features/admin/lesson/data/repositories/admin_lesson_repository_impl.dart';
import 'package:student_platform/features/admin/lesson/domain/usecases/admin_add_lesson.dart';
import 'package:student_platform/features/admin/lesson/domain/repositories/admin_lesson_repository.dart';
import 'package:student_platform/features/admin/lesson/presentation/bloc/lesson_admin_bloc.dart';
import 'package:student_platform/features/admin/exercise/data/datasources/admin_exercise_remote_datasource.dart';
import 'package:student_platform/features/admin/exercise/data/repositories/admin_exercise_repository_impl.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/add_exercise_with_questions.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/archive_exercise.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/fetch_exercises.dart';
import 'package:student_platform/features/admin/exercise/domain/repositories/admin_exercise_repository.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_bloc.dart';
import 'package:student_platform/features/admin/lesson/presentation/bloc/lesson_admin_bloc.dart';
import 'package:student_platform/features/admin/student/data/datasources/student_remote_datasource.dart';
import 'package:student_platform/features/admin/student/data/repositories/student_repository_impl.dart';
import 'package:student_platform/features/admin/student/domain/usecases/add_student.dart';
import 'package:student_platform/features/admin/student/domain/repositories/student_repository.dart';
import 'package:student_platform/features/admin/student/presentation/bloc/student_bloc.dart';
import 'package:student_platform/features/admin/teacher/data/datasources/teacher_remote_datasource.dart';
import 'package:student_platform/features/admin/teacher/data/repositories/teacher_repository_impl.dart';
import 'package:student_platform/features/admin/teacher/domain/usecases/add_teacher.dart';
import 'package:student_platform/features/admin/teacher/domain/repositories/teacher_repository.dart';
import 'package:student_platform/features/admin/teacher/presentation/bloc/teacher_bloc.dart';
import 'package:student_platform/features/admin/circle/data/datasources/circle_remote_datasource.dart';
import 'package:student_platform/features/admin/circle/data/repositories/circle_repository_impl.dart';
import 'package:student_platform/features/admin/circle/domain/usecases/add_circle.dart';
import 'package:student_platform/features/admin/circle/domain/repositories/circle_repository.dart';
import 'package:student_platform/features/admin/circle/presentation/bloc/circle_bloc.dart';
import 'package:student_platform/core/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> init() async { 
  sl.registerFactory(() => LessonBloc(sl()));
  sl.registerLazySingleton(() => GetLessonsForStudent(sl()));
  sl.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LessonRemoteDataSource>(
    () => LessonRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton(() => GetExercisesForLesson(sl()));
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(api: sl()),
  );
  sl.registerFactory(() => ExerciseBloc(sl()));
  sl.registerLazySingleton(() => ApiService());

  sl.registerLazySingleton(() => GetQuestionsForExercise(sl()));
  sl.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<QuestionRemoteDataSource>(
    () => QuestionRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton(() => AdminAddLesson(sl()));
  sl.registerLazySingleton<AdminLessonRepository>(
    () => AdminLessonRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AdminLessonRemoteDataSource>(
    () => AdminLessonRemoteDataSourceImpl(api: sl()),
  );
  sl.registerFactory(() => LessonAdminBloc(sl()));
  sl.registerFactory(() => ExerciseSolverBloc(sl()));
  sl.registerLazySingleton(() => AddExerciseWithQuestions(sl()));
  sl.registerLazySingleton<AdminExerciseRepository>(
    () => AdminExerciseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AdminExerciseRemoteDataSource>(
    () => AdminExerciseRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton(() => ArchiveExercise(sl()));
  sl.registerLazySingleton(() => FetchAll(sl()));
  sl.registerFactory(() => AdminExerciseBloc(
    sl<AddExerciseWithQuestions>(),
    sl<FetchAll>(),
    sl<ArchiveExercise>(),
  )); 
  sl.registerFactory(() => StudentBloc(sl()));
  sl.registerLazySingleton(() => AddStudent(sl()));
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(api: sl()),
  );
  sl.registerFactory(() => CircleBloc(sl()));
  sl.registerLazySingleton(() => AddCircle(sl()));
  sl.registerLazySingleton<CircleRepository>(
    () => CircleRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CircleRemoteDataSource>(
    () => CircleRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<TeacherRemoteDataSource>(() => TeacherRemoteDataSourceImpl(api: sl()));
  sl.registerLazySingleton<TeacherRepository>(() => TeacherRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => AddTeacher(sl()));
  sl.registerFactory(() => TeacherBloc(sl()));
  sl.registerLazySingleton(() => AttemptService(sl()));
  sl.registerLazySingleton(() => AttemptStatusCubit());
  sl.registerLazySingleton(() => ArchiveExerciseCubit());
  sl.registerLazySingleton(() => ArchiveQuestionCubit());
  sl.registerLazySingleton(() => AuthService());
}
