import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/teacher/domain/usecases/add_teacher.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final AddTeacher addTeacher;

  TeacherBloc(this.addTeacher) : super(TeacherInitial()) {
    on<SubmitTeacher>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitTeacher event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      await addTeacher(event.teacher);
      emit(TeacherSuccess());
    } catch (e) {
      emit(TeacherFailure('فشل في إضافة المعلم'));
    }
  }
}
