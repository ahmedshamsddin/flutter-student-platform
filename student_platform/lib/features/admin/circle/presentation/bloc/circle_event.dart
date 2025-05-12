import 'package:equatable/equatable.dart';
import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';

abstract class CircleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitCircle extends CircleEvent {
  final Circle circle;

  SubmitCircle(this.circle);

  @override
  List<Object?> get props => [circle];
}
