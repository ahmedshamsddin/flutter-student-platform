import '../models/question_model.dart';
import '../../../../../core/api/api_service.dart';

abstract class QuestionRemoteDataSource {
  Future<List<QuestionModel>> fetchQuestionsForExercise(int exerciseId);
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final ApiService api;

  QuestionRemoteDataSourceImpl({required this.api});

  @override
  Future<List<QuestionModel>> fetchQuestionsForExercise(int exerciseId) async {
    final response = await api.get('/exercises/$exerciseId/questions');
    return (response as List)
        .map((q) => QuestionModel.fromJson(q))
        .toList();
  }
}
