import 'admin_answer.dart';

class AdminQuestion {
  int? id;
  String text;
  List<AdminAnswer> answers;
  bool? archived;

  AdminQuestion({
    this.id,
    required this.text,
    required this.answers,
    this.archived,
  });
}
