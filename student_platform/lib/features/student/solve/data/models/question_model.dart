import '../../domain/entities/question.dart';
import 'answer_model.dart';

class QuestionModel extends Question {
  QuestionModel({
    required int id,
    required String text,
    required List<AnswerModel> answers,
  }) : super(id: id, text: text, answers: answers);

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      answers: (json['answers'] as List)
          .map((a) => AnswerModel.fromJson(a))
          .toList(),
    );
  }
}
