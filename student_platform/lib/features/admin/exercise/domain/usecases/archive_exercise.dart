import 'package:student_platform/features/admin/exercise/domain/repositories/admin_exercise_repository.dart';

class ArchiveExercise {
  final AdminExerciseRepository repository;

  ArchiveExercise(this.repository);

  Future<void> call(int exerciseId) {
    return repository.archiveExercise(exerciseId);
  }
}
