import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getExercisesForLesson(int lessonId);
}
