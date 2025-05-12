import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/lesson/domain/usecases/admin_add_lesson.dart';
import 'lesson_admin_event.dart';
import 'lesson_admin_state.dart';

class LessonAdminBloc extends Bloc<LessonAdminEvent, LessonAdminState> {
  final AdminAddLesson addLesson;

  LessonAdminBloc(this.addLesson) : super(LessonInitial()) {
    on<SubmitLesson>(_onSubmitLesson);
  }

  Future<void> _onSubmitLesson(
    SubmitLesson event, Emitter<LessonAdminState> emit) async {
    emit(LessonLoading());
    try {
      print(event.title);
      final lesson = await addLesson(event.title, event.instituteId);
      emit(LessonSuccess(lesson));
    } catch (e) {
      print(e);
      emit(LessonFailure('فشل في إضافة الدرس'));
    }
  }
}
