import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

class GetExercisesForLesson {
  final ExerciseRepository repository;

  GetExercisesForLesson(this.repository);

  Future<List<Exercise>> call(int lessonId) {
    return repository.getExercisesForLesson(lessonId);
  }
}
