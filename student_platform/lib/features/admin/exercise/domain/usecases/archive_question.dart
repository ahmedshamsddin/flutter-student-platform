import 'package:student_platform/features/admin/exercise/domain/repositories/admin_question_repository.dart';

class ArchiveQuestion {
  final AdminQuestionRepository repository;

  ArchiveQuestion(this.repository);

  Future<void> call(int questionId) {
    return repository.archiveQuestion(questionId);
  }
}
