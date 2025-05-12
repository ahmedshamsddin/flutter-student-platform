import '../../domain/entities/answer.dart';

abstract class ExerciseSolverEvent {}

class LoadQuestions extends ExerciseSolverEvent {
  final int exerciseId;

  LoadQuestions(this.exerciseId);
}

class SelectAnswer extends ExerciseSolverEvent {
  final int questionId;
  final Answer selectedAnswer;

  SelectAnswer({required this.questionId, required this.selectedAnswer});
}

class GoToNextQuestion extends ExerciseSolverEvent {}

class SubmitExercise extends ExerciseSolverEvent {}
