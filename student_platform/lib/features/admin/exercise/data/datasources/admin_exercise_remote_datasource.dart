import 'package:student_platform/features/admin/exercise/data/models/admin_exercise_model.dart';
import 'package:student_platform/features/admin/lesson/data/models/admin_lesson_model.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class AdminExerciseRemoteDataSource {
  Future<void> addExercise(AdminExerciseModel exercise);
  Future<List<AdminLesson>> fetchAll();
  Future<void> archiveExercise(int id);
}

class AdminExerciseRemoteDataSourceImpl implements AdminExerciseRemoteDataSource {
  final ApiService api;

  AdminExerciseRemoteDataSourceImpl({required this.api});

  @override
  Future<void> addExercise(AdminExerciseModel exercise) async {
    await api.post('/admin/exercises', exercise.toJson());
  }


  @override
  Future<List<AdminLesson>> fetchAll() async {
    final response = await api.get('/lessons/exercises');
    final lessons = (response as List).map((json) => AdminLessonModel.fromJson(json)).toList();
    return lessons;
  }

  @override
  Future<void> archiveExercise(int exerciseId) async {
    await api.patch('/admin/exercises/$exerciseId/archive', {});
  }
}