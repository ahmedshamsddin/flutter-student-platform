class AnswerSubmissionModel {
  final int questionId;
  final int answerId;
  final bool isCorrect;

  AnswerSubmissionModel({
    required this.questionId,
    required this.answerId,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'answer_id': answerId,
        'is_correct': isCorrect,
      };
}
