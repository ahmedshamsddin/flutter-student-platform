import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';

abstract class CircleRepository {
  Future<void> addCircle(Circle circle);
}
