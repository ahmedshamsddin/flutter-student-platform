import 'package:equatable/equatable.dart';

abstract class CircleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CircleSuccess extends CircleState {}

class CircleFailure extends CircleState {
  final String message;

  CircleFailure(this.message);

  @override
  List<Object?> get props => [message];
}
