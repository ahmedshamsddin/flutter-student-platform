import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Lesson>> getLessonsForStudent(int studentId) {
    return remoteDataSource.fetchLessonsForStudent(studentId);
  }
}
