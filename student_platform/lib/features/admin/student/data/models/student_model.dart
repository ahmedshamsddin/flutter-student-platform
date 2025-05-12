import 'package:student_platform/features/admin/student/domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    required super.name,
    required super.email,
    required super.password,
    required super.circleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'circle_id': circleId,
    };
  }
}
