import 'package:equatable/equatable.dart';

abstract class TeacherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherSuccess extends TeacherState {}

class TeacherFailure extends TeacherState {
  final String message;

  TeacherFailure(this.message);
}
