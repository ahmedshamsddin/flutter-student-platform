import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessonsForStudent(int studentId);
}