import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_bloc.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_event.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_state.dart';
import 'package:student_platform/features/admin/archive/archive_exercise_cubit.dart';
import 'package:student_platform/features/admin/archive/archive_question_cubit.dart';
import 'package:student_platform/core/api/api_service.dart';

class ArchiveExerciseScreen extends StatefulWidget {
  const ArchiveExerciseScreen({super.key});

  @override
  State<ArchiveExerciseScreen> createState() => _ArchiveExerciseScreenState();
}

class _ArchiveExerciseScreenState extends State<ArchiveExerciseScreen> {
  final Map<int, bool> _expandedLessons = {};

  @override
  void initState() {
    super.initState();

    final bloc = context.read<AdminExerciseBloc>();
    if (bloc.state is! LessonsLoaded) {
      // bloc.add(FetchLessons());
      print("lessons added");
    }

    Future.microtask(() {
      final exerciseState = bloc.state;

      if (exerciseState is LessonsLoaded) {
        final lessons = exerciseState.lessons;

        final archiveExerciseCubit = context.read<ArchiveExerciseCubit>();
        final exerciseArchiveMap = <int, bool>{
          for (var lesson in lessons)
            for (var ex in lesson.exercises ?? [])
              ex.id!: ex.archived ?? false,
        };
        archiveExerciseCubit.initialize(exerciseArchiveMap);

        final archiveQuestionCubit = context.read<ArchiveQuestionCubit>();
        final questionArchiveMap = <int, bool>{
          for (var lesson in lessons)
            for (var ex in lesson.exercises ?? [])
              for (var q in ex.questions)
                q.id: q.archived ?? false,
        };
        archiveQuestionCubit.initialize(questionArchiveMap);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FA),
        appBar: AppBar(  
          title: const Text('أرشفة التمارين'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<AdminExerciseBloc, AdminExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseFailure) {
              return Center(child: Text(state.message));
            } else if (state is LessonsLoaded) {
              final lessons = state.lessons;

              return (lessons as List).isEmpty
               ? Text("لا يوجد دروس") 
               : ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final isExpanded = _expandedLessons[lesson.id] ?? false;
                  final exercises = lesson.exercises ?? [];

                  return Card(
                    margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                    child: ExpansionTile(
                      key: ValueKey(lesson.id),
                      leading: const Icon(Icons.menu_book),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      iconColor: Colors.teal,
                      collapsedTextColor: Colors.black,
                      collapsedIconColor: Colors.teal,
                      title: Text(
                        lesson.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() => _expandedLessons[lesson.id!] = expanded);
                      },
                      children: exercises.map((exercise) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F7FA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      const Icon(Icons.quiz_outlined, color: Colors.teal, size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        exercise.title,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(exercise.type),
                                  trailing: BlocBuilder<ArchiveExerciseCubit, ArchiveExerciseState>(
                                    builder: (context, archiveState) {
                                      final isArchived = archiveState.archiveStatus[exercise.id] ?? exercise.archived!;
                                      return Switch(
                                        value: isArchived,
                                        activeColor: Colors.teal,
                                        onChanged: (value) async {
                                          await sl<ApiService>().patch('/admin/exercises/${exercise.id}/archive', {});
                                          context.read<ArchiveExerciseCubit>().updateStatus(exercise.id!, !isArchived);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if ((exercise.questions?.isNotEmpty ?? false))
                              Padding(
                                padding: const EdgeInsets.only(right: 32.0),
                                child: Column(
                                  children: exercise.questions!.map((question) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F7FA),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                           child: Row(
                                              children: [
                                                const Icon(Icons.help_outline, color: Colors.blueGrey, size: 18),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    'سؤال: ${question.text}',
                                                    style: const TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          BlocBuilder<ArchiveQuestionCubit, ArchiveQuestionState>(
                                            builder: (context, questionState) {
                                              final isArchived = questionState.archiveStatus[question.id] ?? question.archived ?? false;
                                              return Switch(
                                                value: isArchived,
                                                activeColor: Colors.teal,
                                                onChanged: (value) async {
                                                  await sl<ApiService>().patch('/admin/questions/${question.id}/archive', {});
                                                  context.read<ArchiveQuestionCubit>().updateStatus(question.id!, !isArchived);
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      }).toList(),  
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
