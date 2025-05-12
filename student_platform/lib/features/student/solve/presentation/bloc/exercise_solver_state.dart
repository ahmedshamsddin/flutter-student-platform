
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';

abstract class ExerciseSolverState {}

class SolverInitial extends ExerciseSolverState {}

class SolverLoading extends ExerciseSolverState {}

class SolverLoaded extends ExerciseSolverState {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, Answer> selectedAnswers;
  final int exerciseId;

  SolverLoaded({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.exerciseId,
  });
}

class SolverCompleted extends ExerciseSolverState {
  final int score;
  final int total;

  SolverCompleted({required this.score, required this.total});
}

class SolverError extends ExerciseSolverState {
  final String message;

  SolverError(this.message);
}
