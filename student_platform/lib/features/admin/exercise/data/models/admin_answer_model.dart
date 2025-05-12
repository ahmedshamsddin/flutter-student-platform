import 'package:student_platform/features/admin/exercise/domain/entities/admin_answer.dart';

class AdminAnswerModel extends AdminAnswer {
  AdminAnswerModel({
    required super.text,
    required super.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'is_correct': isCorrect,
  };

  factory AdminAnswerModel.fromJson(Map<String, dynamic> json) {
    return AdminAnswerModel(
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }
}
