import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/add_exercise_with_questions.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/archive_exercise.dart';
import 'package:student_platform/features/admin/exercise/domain/usecases/fetch_exercises.dart';
import 'admin_exercise_event.dart';
import 'admin_exercise_state.dart';

class AdminExerciseBloc extends Bloc<AdminExerciseEvent, AdminExerciseState> {
  final AddExerciseWithQuestions addExercise;
  final FetchAll fetchAll;
  final ArchiveExercise archive;

  AdminExerciseBloc(this.addExercise, this.fetchAll, this.archive) : super(ExerciseInitial()) {
    on<SubmitExercise>(_onSubmitExercise);
    on<FetchLessons>(_onFetch);
    on<ArchiveExerciseEvent>(_onArchive);
    on<ToggleArchiveExercise>(_onToggleArchiveExercise);
  }

  Future<void> _onToggleArchiveExercise(
    ToggleArchiveExercise event,
    Emitter<AdminExerciseState> emit,
  ) async {
    try {
      await archive(event.exerciseId);
      add(FetchLessons());
    } catch (e) {
      print(e);
      emit(ExerciseFailure("Failed to update archive status"));
    }
  }

  Future<void> _onSubmitExercise(
    SubmitExercise event,
    Emitter<AdminExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      await addExercise(event.exercise);
      emit(ExerciseSuccess());
    } catch (e) {
      emit(ExerciseFailure('فشل في إضافة التمرين'));
    }
  }

  Future<void> _onFetch(FetchLessons event, Emitter emit) async {
    emit(ExerciseLoading());
    final test = await fetchAll();
    print(test);
    try {
      final list = await fetchAll();
      emit(LessonsLoaded(list));
    } catch (e) {
      emit(ExerciseFailure('Failed to load exercises'));
    }
  }

  Future<void> _onArchive(ArchiveExerciseEvent event, Emitter emit) async {
    try {
      await archive(event.exerciseId);
      add(FetchLessons()); // Refresh
    } catch (_) {
      emit(ExerciseFailure('Failed to archive'));
    }
  }
}
