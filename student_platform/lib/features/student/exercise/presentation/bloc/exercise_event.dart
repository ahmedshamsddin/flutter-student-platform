abstract class ExerciseEvent {}

class FetchExercises extends ExerciseEvent {
  final int lessonId;

  FetchExercises(this.lessonId);
}
