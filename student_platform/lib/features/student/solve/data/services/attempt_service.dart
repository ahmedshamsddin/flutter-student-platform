import 'package:student_platform/core/api/api_service.dart';
import '../models/answer_submission_model.dart';

class AttemptService {
  final ApiService api;

  AttemptService(this.api);

  Future<void> submitAttempt({
    required int studentId,
    required int exerciseId,
    required int score,
    required List<AnswerSubmissionModel> answers,
  }) async {
    final body = {
      'student_id': studentId,
      'exercise_id': exerciseId,
      'score': score,
      'answers': answers.map((a) => a.toJson()).toList(),
    };

    await api.post('/attempts', body);
  }

 Future<int?> getLatestScore({
  required int studentId,
  required int exerciseId,
 }) async {
 	print(exerciseId);
  final response = await api.get(
    '/attempts/latest?student_id=$studentId&exercise_id=$exerciseId',
   );
  return response['score'] as int?; // will be null if no attempt
}

}
