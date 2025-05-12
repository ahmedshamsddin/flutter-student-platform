import 'package:student_platform/features/admin/exercise/data/models/admin_question_model.dart';
import 'package:student_platform/features/admin/lesson/data/models/admin_lesson_model.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_question.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class AdminQuestionRemoteDataSource {
  Future<void> archiveQuestion(int id);
}

class AdminQuestionRemoteDataSourceImpl implements AdminQuestionRemoteDataSource {
  final ApiService api;

  AdminQuestionRemoteDataSourceImpl({required this.api});

  @override
  Future<void> archiveQuestion(int questionId) async {
    await api.patch('/admin/questions/$questionId/archive', {});
  }
}