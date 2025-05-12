import 'package:student_platform/features/admin/circle/data/models/circle_model.dart';
import 'package:student_platform/core/api/api_service.dart';

abstract class CircleRemoteDataSource {
  Future<void> addCircle(CircleModel circle);
}

class CircleRemoteDataSourceImpl implements CircleRemoteDataSource {
  final ApiService api;

  CircleRemoteDataSourceImpl({required this.api});

  @override
  Future<void> addCircle(CircleModel circle) async {
    await api.post('/admin/circles', circle.toJson());
  }
}