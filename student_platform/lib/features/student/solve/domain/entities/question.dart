import 'answer.dart';

class Question {
  final int id;
  final String text;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.text,
    required this.answers,
  });
}
