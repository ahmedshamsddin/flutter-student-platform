import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/question_remote_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSource remoteDataSource;

  QuestionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Question>> getQuestionsForExercise(int exerciseId) {
    return remoteDataSource.fetchQuestionsForExercise(exerciseId);
  }
}
