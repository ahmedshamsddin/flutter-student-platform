import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/features/admin/exercise/domain/repositories/admin_exercise_repository.dart';
import 'package:student_platform/features/admin/exercise/data/datasources/admin_exercise_remote_datasource.dart';
import 'package:student_platform/features/admin/exercise/data/models/admin_exercise_model.dart';
import 'package:student_platform/features/admin/lesson/data/models/admin_lesson_model.dart';

class AdminExerciseRepositoryImpl implements AdminExerciseRepository {
  final AdminExerciseRemoteDataSource remoteDataSource;

  AdminExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addExercise(AdminExercise exercise) {
    final model = AdminExerciseModel(
      lessonId: exercise.lessonId,
      title: exercise.title,
      type: exercise.type,
      questions: exercise.questions,
    );
    return remoteDataSource.addExercise(model);
  }

  @override
  Future<List<AdminLesson>> fetchAll() {
    return remoteDataSource.fetchAll();
  }
  
  @override
  Future<void> archiveExercise(int exerciseId) {
    return remoteDataSource.archiveExercise(exerciseId);
  }
}
