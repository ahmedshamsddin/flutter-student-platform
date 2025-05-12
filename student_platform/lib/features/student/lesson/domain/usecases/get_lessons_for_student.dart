import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsForStudent {
  final LessonRepository repository;

  GetLessonsForStudent(this.repository);

  Future<List<Lesson>> call(int studentId) {
    return repository.getLessonsForStudent(studentId);
  }
}
