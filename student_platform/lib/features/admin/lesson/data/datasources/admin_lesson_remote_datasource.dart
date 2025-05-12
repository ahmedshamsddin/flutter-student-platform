import 'package:student_platform/features/admin/lesson/data/models/admin_lesson_model.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class AdminLessonRemoteDataSource {
  Future<AdminLessonModel> addLesson(String title, int instituteId);
}

class AdminLessonRemoteDataSourceImpl implements AdminLessonRemoteDataSource {
  final ApiService api;

  AdminLessonRemoteDataSourceImpl({required this.api});

  @override
  Future<AdminLessonModel> addLesson(String title, int instituteId) async {
    final response = await api.post('/admin/lessons', {
      'title': title,
      'institute_id': instituteId,
    });
    print(response);
    return AdminLessonModel.fromJson(response);
  }
}