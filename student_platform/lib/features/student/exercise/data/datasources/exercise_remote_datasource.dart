import '../models/exercise_model.dart';
import '../../../../../core/api/api_service.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> fetchExercisesForLesson(int lessonId);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ApiService api;

  ExerciseRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ExerciseModel>> fetchExercisesForLesson(int lessonId) async {
    final response = await api.get('/lessons/$lessonId/exercises');
    return (response as List)
        .map((json) => ExerciseModel.fromJson(json))
        .toList();
  }
}
