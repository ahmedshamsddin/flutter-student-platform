import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/student/domain/usecases/add_student.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final AddStudent addStudent;

  StudentBloc(this.addStudent) : super(StudentInitial()) {
    on<SubmitStudent>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitStudent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await addStudent(event.student);
      emit(StudentSuccess());
    } catch (_) {
      emit(StudentFailure('Failed to add student'));
    }
  }
}
