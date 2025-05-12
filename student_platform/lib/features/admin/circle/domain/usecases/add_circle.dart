import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';
import 'package:student_platform/features/admin/circle/domain/repositories/circle_repository.dart';

class AddCircle {
  final CircleRepository repository;

  AddCircle(this.repository);

  Future<void> call(Circle circle) {
    return repository.addCircle(circle);
  }
}
