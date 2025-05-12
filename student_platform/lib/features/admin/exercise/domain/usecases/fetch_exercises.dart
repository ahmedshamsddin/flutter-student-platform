import 'package:student_platform/features/admin/exercise/domain/repositories/admin_exercise_repository.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';

class FetchAll {
  final AdminExerciseRepository repository;

  FetchAll(this.repository);

  Future<List<AdminLesson>> call() {
    return repository.fetchAll();
  }
}
