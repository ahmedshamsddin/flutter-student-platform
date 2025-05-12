import 'package:equatable/equatable.dart';

abstract class LessonAdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitLesson extends LessonAdminEvent {
  final String title;
  final int instituteId;

  SubmitLesson(this.title, this.instituteId);

  @override
  List<Object?> get props => [title, instituteId];
}
