import 'package:student_platform/features/admin/student/domain/entities/student.dart';

abstract class StudentRepository {
  Future<void> addStudent(Student student);
}
