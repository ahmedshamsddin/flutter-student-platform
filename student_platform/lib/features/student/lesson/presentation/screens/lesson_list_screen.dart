import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/student/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:student_platform/features/student/lesson/presentation/bloc/lesson_event.dart';
import 'package:student_platform/features/student/lesson/presentation/bloc/lesson_state.dart';
import 'package:student_platform/features/student/exercise/presentation/screens/exercise_list_screen.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/core/services/auth_service.dart';
import 'package:student_platform/features/auth/presentation/screens/login_screen.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonListScreen extends StatelessWidget {
  final int studentId;

  const LessonListScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LessonBloc>()..add(LoadLessons(1)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'دروسي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await sl<AuthService>().logout();

                  final prefs = await SharedPreferences.getInstance();
                  final keysToDelete = prefs.getKeys().where((k) => k.startsWith('attempt_scores_user_'));
                  for (final key in keysToDelete) {
                    await prefs.remove(key);
                  }

                  sl<AttemptStatusCubit>().emit(AttemptStatusState(exerciseScores: {}));

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  }
                },
              )
            ],

          ),
          body: BlocBuilder<LessonBloc, LessonState>(
            builder: (context, state) {
              if (state is LessonLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LessonLoaded) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lesson = state.lessons[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExerciseListScreen(
                              lessonId: lesson.id,
                              lessonTitle: lesson.title,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              child: Text(
                                lesson.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_back_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is LessonError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox.shrink();
            },
          ),
          backgroundColor: const Color(0xFFF5F7FA),
        ),
      ),
    );
  }
}
