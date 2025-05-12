import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/exercise/data/models/admin_answer_model.dart';
import 'admin_question_model.dart';

class AdminExerciseModel extends AdminExercise {
  AdminExerciseModel({
    super.id,
    required super.lessonId,
    required super.title,
    required super.type,
    super.questions,
    super.archived,
  });

  Map<String, dynamic> toJson() => {
    'lesson_id': lessonId,
    'type': type,
    'title': title,
    'questions': questions?.asMap().entries.map((entry) {
      final index = entry.key;
      final q = entry.value;
      return {
        'text': q.text,
        'order': index,
        'answers': q.answers.map((a) {
          return AdminAnswerModel(text: a.text, isCorrect: a.isCorrect).toJson();
        }).toList(),
      };
    }).toList()
  };

  factory AdminExerciseModel.fromJson(Map<String, dynamic> json) {
    final questionList = json['questions'] as List?;
    return AdminExerciseModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      title: json['title'],
      type: json['type'],
      questions: (questionList != null && (questionList as List).isNotEmpty)
        ? questionList.map((q) => AdminQuestionModel.fromJson(q)).toList()
        : [],
      archived: json['archived'] ?? false,
    );
  }
}
