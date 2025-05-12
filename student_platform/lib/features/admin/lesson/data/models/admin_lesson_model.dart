import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/features/admin/exercise/data/models/admin_exercise_model.dart';

class AdminLessonModel extends AdminLesson {
  AdminLessonModel({
    required super.id,
    required super.title,
    required super.instituteId,
    List<AdminExerciseModel>? super.exercises,
  });

  factory AdminLessonModel.fromJson(Map<String, dynamic> json) {
    final exercisesJson = json['exercises'];
    //final exercises = (json['exercises'] as List).map((e) => AdminExerciseModel.fromJson(e)).toList();
    return AdminLessonModel(
      id: json['id'],
      title: json['title'],
      instituteId: json['institute_id'],
      exercises: (json['exercises'] != null && (json['exercises'] as List).isNotEmpty)
          ? (json['exercises'] as List)
              .map((e) => AdminExerciseModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'institute_id': instituteId,
    };
  }
}
