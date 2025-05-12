import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';
import 'package:student_platform/features/admin/teacher/domain/repositories/teacher_repository.dart';
import 'package:student_platform/features/admin/teacher/data/datasources/teacher_remote_datasource.dart';
import 'package:student_platform/features/admin/teacher/data/models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addTeacher(Teacher teacher) {
    final model = TeacherModel(
      name: teacher.name,
      email: teacher.email,
      password: teacher.password,
      circleId: teacher.circleId,
    );
    return remoteDataSource.addTeacher(model);
  }
}