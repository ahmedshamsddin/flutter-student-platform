import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';

class TeacherModel extends Teacher {
  TeacherModel({
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

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      name: json['name'],
      email: json['email'],
      password: '', // never load plain password from backend
      circleId: json['circle_id'],
    );
  }
}
