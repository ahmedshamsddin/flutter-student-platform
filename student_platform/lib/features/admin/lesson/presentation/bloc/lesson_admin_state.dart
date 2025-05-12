import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';

abstract class LessonAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonAdminState {}

class LessonLoading extends LessonAdminState {}

class LessonSuccess extends LessonAdminState {
  final AdminLesson lesson;

  LessonSuccess(this.lesson);

  @override
  List<Object?> get props => [lesson];
}

class LessonFailure extends LessonAdminState {
  final String message;

  LessonFailure(this.message);

  @override
  List<Object?> get props => [message];
}
