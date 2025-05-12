import 'package:equatable/equatable.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {}

class StudentFailure extends StudentState {
  final String message;

  StudentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
