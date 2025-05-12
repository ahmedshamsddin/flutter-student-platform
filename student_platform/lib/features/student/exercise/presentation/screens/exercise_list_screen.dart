import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:student_platform/features/student/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:student_platform/features/student/exercise/presentation/bloc/exercise_event.dart';
import 'package:student_platform/features/student/exercise/presentation/bloc/exercise_state.dart';
import 'package:student_platform/features/student/solve/presentation/screens/solve_exercise_screen.dart';

class ExerciseListScreen extends StatelessWidget {
  final int lessonId;
  final String lessonTitle;

  const ExerciseListScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ExerciseBloc>()..add(FetchExercises(lessonId))),
        BlocProvider.value(value: sl<AttemptStatusCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'التمارين - $lessonTitle',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
          ),
          backgroundColor: const Color(0xFFF5F7FA),
          body: BlocBuilder<ExerciseBloc, ExerciseState>(
            builder: (context, state) {
              if (state is ExerciseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExerciseLoaded) {
                if (state.exercises.isEmpty) {
                  return const Center(child: Text('لا توجد تمارين متاحة.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final exercise = state.exercises[index];
                    final score = context.watch<AttemptStatusCubit>().getScore(exercise.id);
                    print(exercise.questionCount);
                    final totalScore = exercise.questionCount * 10;
                    final alreadyCompleted = score != null && score == totalScore;
                    return GestureDetector(
                      onTap: alreadyCompleted 
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SolveExerciseScreen(exerciseId: exercise.id),
                                ),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: alreadyCompleted ? const Color(0xFFF1F8E9) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_outlined, color: Color(0xFF1E88E5)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(exercise.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (alreadyCompleted)
                              const Icon(Icons.check_circle, color: Colors.green)
                            else
                              const Icon(Icons.arrow_back_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ExerciseError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
