import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/features/admin/lesson/domain/repositories/admin_lesson_repository.dart';
import 'package:student_platform/features/admin/lesson/data/datasources/admin_lesson_remote_datasource.dart';

class AdminLessonRepositoryImpl implements AdminLessonRepository {
  final AdminLessonRemoteDataSource remoteDataSource;

  AdminLessonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminLesson> addLesson(String title, int instituteId) {
    return remoteDataSource.addLesson(title, instituteId);
  }
}
