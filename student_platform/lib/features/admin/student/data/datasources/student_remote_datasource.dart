import 'package:student_platform/features/admin/student/data/models/student_model.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class StudentRemoteDataSource {
  Future<void> addStudent(StudentModel student);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final ApiService api;

  StudentRemoteDataSourceImpl({required this.api});

  @override
  Future<void> addStudent(StudentModel student) async {
    await api.post('/admin/students', student.toJson());
  }
}
