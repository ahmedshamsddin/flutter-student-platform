import 'package:student_platform/features/admin/student/domain/entities/student.dart';
import 'package:student_platform/features/admin/student/domain/repositories/student_repository.dart';

class AddStudent {
  final StudentRepository repository;

  AddStudent(this.repository);

  Future<void> call(Student student) {
    return repository.addStudent(student);
  }
}
