import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_lessons_for_student.dart';
import 'lesson_event.dart';
import 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GetLessonsForStudent getLessonsForStudent;

  LessonBloc(this.getLessonsForStudent) : super(LessonInitial()) {
    on<LoadLessons>((event, emit) async {
      emit(LessonLoading());
      try {
        final lessons = await getLessonsForStudent(event.studentId);
        emit(LessonLoaded(lessons));
      } catch (e) {
        print(e);
        emit(LessonError('حدث خطأ أثناء تحميل الدروس'));
      }
    });
  }
}
