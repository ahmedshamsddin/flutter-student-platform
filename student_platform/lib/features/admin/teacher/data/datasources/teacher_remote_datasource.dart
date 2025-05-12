import 'package:student_platform/features/admin/teacher/data/models/teacher_model.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class TeacherRemoteDataSource {
  Future<void> addTeacher(TeacherModel teacher);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final ApiService api;

  TeacherRemoteDataSourceImpl({required this.api});

  @override
  Future<void> addTeacher(TeacherModel teacher) async {
    await api.post('/admin/teachers', teacher.toJson());
  }
}