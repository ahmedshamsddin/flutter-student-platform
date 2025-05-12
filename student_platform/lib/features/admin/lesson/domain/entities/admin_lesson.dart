import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';

class AdminLesson {
  final int id;
  final String title;
  final int instituteId;
  final List<AdminExercise>? exercises;

  AdminLesson({
    required this.id,
    required this.title,
    required this.instituteId,
    this.exercises
  });
}
