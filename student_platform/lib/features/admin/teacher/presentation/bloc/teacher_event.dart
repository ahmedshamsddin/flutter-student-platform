import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';

abstract class TeacherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitTeacher extends TeacherEvent {
  final Teacher teacher;

  SubmitTeacher(this.teacher);

  @override
  List<Object?> get props => [teacher];
}
