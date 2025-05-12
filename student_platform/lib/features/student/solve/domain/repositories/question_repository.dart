import '../entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestionsForExercise(int exerciseId);
}
