import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/student/exercise/domain/usecases/get_exercises_for_lesson.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesForLesson getExercisesForLesson;

  ExerciseBloc(this.getExercisesForLesson) : super(ExerciseInitial()) {
    on<FetchExercises>(_onFetchExercises);
  }

  Future<void> _onFetchExercises(
    FetchExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await getExercisesForLesson(event.lessonId);
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError('فشل في تحميل التمارين'));
    }
  }
}
