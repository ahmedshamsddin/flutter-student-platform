import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';

class CircleModel extends Circle {
  const CircleModel({
    int? id,
    required String name,
    required int centerId,
  }) : super(id: id, name: name, centerId: centerId);

  Map<String, dynamic> toJson() => {
    'name': name,
    'center_id': centerId,
  };

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'],
      name: json['name'],
      centerId: json['center_id'],
    );
  }
}
