import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';

abstract class AdminExerciseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitExercise extends AdminExerciseEvent {
  final AdminExercise exercise;

  SubmitExercise(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class ToggleArchiveExercise extends AdminExerciseEvent {
  final int exerciseId;

  ToggleArchiveExercise(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class FetchLessons extends AdminExerciseEvent {}

class ArchiveExerciseEvent extends AdminExerciseEvent {
  final int exerciseId;

  ArchiveExerciseEvent(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

