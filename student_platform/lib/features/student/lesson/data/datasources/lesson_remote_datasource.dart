import '../models/lesson_model.dart';
import '../../../../../core/api/api_service.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> fetchLessonsForStudent(int studentId);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiService api;

  LessonRemoteDataSourceImpl({required this.api});

  @override
  Future<List<LessonModel>> fetchLessonsForStudent(int studentId) async {
    final response = await api.get('/students/$studentId/lessons');
    return (response as List)
        .map((json) => LessonModel.fromJson(json))
        .toList();
  }
}
