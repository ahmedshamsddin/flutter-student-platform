import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';

abstract class TeacherRepository {
  Future<void> addTeacher(Teacher teacher);
}
