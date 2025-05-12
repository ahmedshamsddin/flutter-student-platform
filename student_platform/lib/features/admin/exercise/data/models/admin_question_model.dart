import 'package:student_platform/features/admin/exercise/domain/entities/admin_question.dart';
import 'admin_answer_model.dart';

class AdminQuestionModel extends AdminQuestion {
  AdminQuestionModel({
    super.id,
    required super.text,
    required super.answers,
    super.archived,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'archived': archived,
    'answers': answers.map((a) => AdminAnswerModel(text: a.text, isCorrect: a.isCorrect).toJson()).toList(),
  };

  factory AdminQuestionModel.fromJson(Map<String, dynamic> json) {
    final answersList = json['answers'] as List?;
    print(json['id']);
    return AdminQuestionModel(
      id: json['id'],
      text: json['text'],
      archived: json['archived'],
      answers: (answersList != null) && ((answersList as List).isNotEmpty)
       ? answersList.map((a) => AdminAnswerModel.fromJson(a)).toList()
       : [],
    );
  }
  
  // Map<String, dynamic> toJson() => {
  //   'text': text,
  //   'archived': archived,
  //   'answers': answers.map((a) => AdminAnswerModel.fromEntity(a).toJson()).toList(),
  // };

  static AdminQuestionModel fromEntity(AdminQuestion question) {
    return AdminQuestionModel(
      id: question.id,
      text: question.text,
      archived: question.archived,
      answers: question.answers,
    );
  }
}
