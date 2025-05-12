import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/solve/presentation/bloc/exercise_solver_bloc.dart';
import 'package:student_platform/features/student/solve/presentation/bloc/exercise_solver_event.dart';
import 'package:student_platform/features/student/solve/presentation/bloc/exercise_solver_state.dart';
import 'package:student_platform/features/student/solve/domain/entities/question.dart';
import 'package:student_platform/features/student/solve/domain/entities/answer.dart';

class SolveExerciseScreen extends StatelessWidget {
  final int exerciseId;

  const SolveExerciseScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExerciseSolverBloc>()..add(LoadQuestions(exerciseId)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(
            title: const Text('حل التمرين'),
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          body: BlocBuilder<ExerciseSolverBloc, ExerciseSolverState>(
            builder: (context, state) {
              if (state is SolverLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SolverError) {
                return Center(child: Text(state.message));
              } else if (state is SolverCompleted) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        'نتيجتك: ${state.score} من ${state.total}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (state.score < state.total)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ExerciseSolverBloc>()
                                  .add(LoadQuestions(exerciseId));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child: Text('أعد المحاولة', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              } else if (state is SolverLoaded) {
                final currentQuestion = state.questions[state.currentIndex];
                final selected = state.selectedAnswers[currentQuestion.id];

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Column(
                      key: ValueKey(currentQuestion.id),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'السؤال ${state.currentIndex + 1} من ${state.questions.length}',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            currentQuestion.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...currentQuestion.answers.map((answer) {
                          final isSelected = selected?.id == answer.id;
                          return GestureDetector(
                            onTap: () {
                              context.read<ExerciseSolverBloc>().add(
                                    SelectAnswer(
                                      questionId: currentQuestion.id,
                                      selectedAnswer: answer,
                                    ),
                                  );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? const Color(0xFFE0F2F1) : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                answer.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF388E3C)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        const Spacer(),
                        if (state.currentIndex > 0)
                          TextButton(
                            onPressed: () {
                              context.read<ExerciseSolverBloc>().emit(
                                    SolverLoaded(
                                      questions: state.questions,
                                      currentIndex: state.currentIndex - 1,
                                      selectedAnswers: state.selectedAnswers,
                                      exerciseId: state.exerciseId,
                                    ),
                                  );
                            },
                            child: const Text(
                              'السابق',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            if (state.currentIndex == state.questions.length - 1) {
                              context
                                  .read<ExerciseSolverBloc>()
                                  .add(SubmitExercise());
                            } else {
                              context
                                  .read<ExerciseSolverBloc>()
                                  .add(GoToNextQuestion());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            state.currentIndex == state.questions.length - 1
                                ? 'إرسال الإجابات'
                                : 'التالي',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
