import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';
import 'package:student_platform/features/admin/circle/domain/repositories/circle_repository.dart';
import 'package:student_platform/features/admin/circle/data/datasources/circle_remote_datasource.dart';
import 'package:student_platform/features/admin/circle/data/models/circle_model.dart';

class CircleRepositoryImpl implements CircleRepository {
  final CircleRemoteDataSource remoteDataSource;

  CircleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addCircle(Circle circle) {
    final model = CircleModel(name: circle.name, centerId: circle.centerId);
    return remoteDataSource.addCircle(model);
  }
}