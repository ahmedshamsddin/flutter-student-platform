import '../../domain/entities/answer.dart';

class AnswerModel extends Answer {
  AnswerModel({
    required int id,
    required String text,
    required bool isCorrect,
  }) : super(id: id, text: text, isCorrect: isCorrect);

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }
}
