import 'package:student_platform/features/admin/lesson/domain/repositories/admin_lesson_repository.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';

class AdminAddLesson {
  final AdminLessonRepository repository;

  AdminAddLesson(this.repository);

  Future<AdminLesson> call(String title, int instituteId) {
    return repository.addLesson(title, instituteId);
  }
}
