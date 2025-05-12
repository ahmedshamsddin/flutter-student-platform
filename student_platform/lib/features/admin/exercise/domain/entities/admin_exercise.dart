import 'admin_question.dart';

class AdminExercise {
  final int? id;
  final int lessonId;
  final String title;
  final String type;
  final List<AdminQuestion>? questions;
  final bool? archived;

  AdminExercise({
    this.id,
    required this.lessonId,
    required this.title,
    required this.type,
    this.questions,
    this.archived
  });
}
