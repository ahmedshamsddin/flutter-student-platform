import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';
import 'package:student_platform/features/admin/teacher/domain/repositories/teacher_repository.dart';

class AddTeacher {
  final TeacherRepository repository;

  AddTeacher(this.repository);

  Future<void> call(Teacher teacher) {
    return repository.addTeacher(teacher);
  }
}
