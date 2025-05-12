import '../entities/question.dart';
import '../repositories/question_repository.dart';

class GetQuestionsForExercise {
  final QuestionRepository repository;

  GetQuestionsForExercise(this.repository);

  Future<List<Question>> call(int exerciseId) {
    return repository.getQuestionsForExercise(exerciseId);
  }
}
