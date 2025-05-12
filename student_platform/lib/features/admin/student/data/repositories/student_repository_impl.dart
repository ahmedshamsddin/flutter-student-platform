import 'package:student_platform/features/admin/student/domain/entities/student.dart';
import 'package:student_platform/features/admin/student/domain/repositories/student_repository.dart';
import 'package:student_platform/features/admin/student/data/datasources/student_remote_datasource.dart';
import 'package:student_platform/features/admin/student/data/models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addStudent(Student student) {
    final model = StudentModel(
      name: student.name,
      email: student.email,
      password: student.password,
      circleId: student.circleId,
    );
    return remoteDataSource.addStudent(model);
  }
}
