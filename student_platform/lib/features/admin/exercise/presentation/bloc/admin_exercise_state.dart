import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';

abstract class AdminExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends AdminExerciseState {}

class ExerciseLoading extends AdminExerciseState {}

class ExerciseSuccess extends AdminExerciseState {}

class LessonsLoaded extends AdminExerciseState {
  final List<AdminLesson> lessons;

  LessonsLoaded(this.lessons);

  @override
  List<Object?> get props => [lessons];
}

class ExerciseFailure extends AdminExerciseState {
  final String message;

  ExerciseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
