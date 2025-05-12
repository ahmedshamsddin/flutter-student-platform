import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';

abstract class AdminExerciseRepository {
  Future<void> addExercise(AdminExercise exercise);
  Future<List<AdminLesson>> fetchAll();
  Future<void> archiveExercise(int exerciseId);
}
