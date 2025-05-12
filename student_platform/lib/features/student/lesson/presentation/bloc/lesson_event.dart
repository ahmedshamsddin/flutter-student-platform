import 'package:equatable/equatable.dart';

abstract class LessonEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLessons extends LessonEvent {
  final int studentId;

  LoadLessons(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
