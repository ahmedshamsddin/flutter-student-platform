import 'package:student_platform/features/admin/exercise/domain/repositories/admin_question_repository.dart';
import 'package:student_platform/features/admin/exercise/data/datasources/admin_question_remote_datasource.dart';

class AdminQuestionRepositoryImpl implements AdminQuestionRepository {
  final AdminQuestionRemoteDataSource remoteDataSource;

  AdminQuestionRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<void> archiveQuestion(int questionId) {
    return remoteDataSource.archiveQuestion(questionId);
  }
}
