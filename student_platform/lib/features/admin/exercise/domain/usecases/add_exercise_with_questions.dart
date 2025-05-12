import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/exercise/domain/repositories/admin_exercise_repository.dart';

class AddExerciseWithQuestions {
  final AdminExerciseRepository repository;

  AddExerciseWithQuestions(this.repository);

  Future<void> call(AdminExercise exercise) {
    return repository.addExercise(exercise);
  }
}
