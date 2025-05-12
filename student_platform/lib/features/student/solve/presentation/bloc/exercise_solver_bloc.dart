import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_questions_for_exercise.dart';
import 'package:student_platform/features/student/solve/domain/entities/answer.dart';
import 'exercise_solver_event.dart';
import 'exercise_solver_state.dart';
import 'package:student_platform/features/student/solve/data/services/attempt_service.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/solve/data/models/answer_submission_model.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:student_platform/core/services/auth_service.dart';

class ExerciseSolverBloc extends Bloc<ExerciseSolverEvent, ExerciseSolverState> {
  final GetQuestionsForExercise getQuestions;

  ExerciseSolverBloc(this.getQuestions) : super(SolverInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SelectAnswer>(_onSelectAnswer);
    on<GoToNextQuestion>(_onNext);
    on<SubmitExercise>(_onSubmit);
  }

  Future<void> _onLoadQuestions(LoadQuestions event, Emitter emit) async {
    emit(SolverLoading());
    try {
      final questions = await getQuestions(event.exerciseId);
      emit(SolverLoaded(
        questions: questions,
        currentIndex: 0,
        selectedAnswers: {},
        exerciseId: event.exerciseId,
      ));
    } catch (_) {
      emit(SolverError('فشل في تحميل الأسئلة'));
    }
  }

  void _onSelectAnswer(SelectAnswer event, Emitter emit) {
    if (state is SolverLoaded) {
      final current = state as SolverLoaded;
      final updatedAnswers = Map<int, Answer>.from(current.selectedAnswers);
      updatedAnswers[event.questionId] = event.selectedAnswer;

      emit(SolverLoaded(
        questions: current.questions,
        currentIndex: current.currentIndex,
        selectedAnswers: updatedAnswers,
        exerciseId: current.exerciseId,
      ));
    }
  }

  void _onNext(GoToNextQuestion event, Emitter emit) {
    if (state is SolverLoaded) {
      final current = state as SolverLoaded;
      if (current.currentIndex < current.questions.length - 1) {
        emit(SolverLoaded(
          questions: current.questions,
          currentIndex: current.currentIndex + 1,
          selectedAnswers: current.selectedAnswers,
          exerciseId: current.exerciseId,
        ));
      }
    }
  }

  Future<void> _onSubmit(SubmitExercise event, Emitter emit) async {
    if (state is SolverLoaded) {
      final current = state as SolverLoaded;

      int score = 0;
      for (var q in current.questions) {
        final selected = current.selectedAnswers[q.id];
        if (selected != null && selected.isCorrect) {
          score += 10;
        } else if (selected != null) {
          score += 5;
        }
      }

      final attemptService = sl<AttemptService>();
      final answerSubmissions = current.questions.map((q) {
        final selected = current.selectedAnswers[q.id];
        return AnswerSubmissionModel(
          questionId: q.id,
          answerId: selected?.id ?? 0,
          isCorrect: selected?.isCorrect ?? false,
        );
      }).toList();
      final studentId = await sl<AuthService>().getUserId(); // assuming async context
      if (studentId != null) {
        await sl<AttemptStatusCubit>().updateScore(studentId, current.exerciseId, score);
      
        await attemptService.submitAttempt(
          studentId: studentId, // TODO: Replace with actual student ID
          exerciseId: current.exerciseId, // or pass it into the bloc
          score: score,
          answers: answerSubmissions,
        );
      }
      emit(SolverCompleted(score: score, total: current.questions.length * 10));
    }
  }
}
