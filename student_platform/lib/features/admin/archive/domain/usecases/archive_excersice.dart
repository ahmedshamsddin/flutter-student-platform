import 'package:student_platform:features/admin/archive/domain/repositories/exercise_repository.dart';

class ArchiveExercise {
  final ExerciseRepository repository;

  ArchiveExercise(this.repository);

  Future<void> call(int exerciseId) {
    return repository.archiveExercise(exerciseId);
  }
}
