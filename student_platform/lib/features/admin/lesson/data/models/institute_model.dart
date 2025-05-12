import 'package:student_platform/features/admin/lesson/domain/entities/institute.dart';

class InstituteModel extends Institute {
  InstituteModel({required int id, required String name})
      : super(id: id, name: name);

  factory InstituteModel.fromJson(Map<String, dynamic> json) {
    return InstituteModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
