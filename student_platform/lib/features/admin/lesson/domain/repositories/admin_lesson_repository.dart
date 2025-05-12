import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';

abstract class AdminLessonRepository {
  Future<AdminLesson> addLesson(String title, int instituteId);
}
