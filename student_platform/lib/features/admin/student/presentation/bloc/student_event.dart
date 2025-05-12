import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/student/domain/entities/student.dart';

abstract class StudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitStudent extends StudentEvent {
  final Student student;

  SubmitStudent(this.student);

  @override
  List<Object?> get props => [student];
}
