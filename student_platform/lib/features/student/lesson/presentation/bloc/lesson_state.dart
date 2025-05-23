import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson.dart';

abstract class LessonState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {
  final List<Lesson> lessons;

  LessonLoaded(this.lessons);

  @override
  List<Object?> get props => [lessons];
}

class LessonError extends LessonState {
  final String message;

  LessonError(this.message);

  @override
  List<Object?> get props => [message];
}
