import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/lesson/presentation/screens/add_lesson_screen.dart';
// TODO: Replace Placeholders below with actual screens once ready
import 'package:student_platform/features/admin/exercise/presentation/screens/add_exercise_screen.dart';
import 'package:student_platform/features/admin/exercise/presentation/screens/archive_exercise_screen.dart';
import 'package:student_platform/features/admin/student/presentation/screens/add_student_screen.dart';
import 'package:student_platform/features/admin/teacher/presentation/screens/add_teacher_screen.dart';
import 'package:student_platform/features/admin/circle/presentation/screens/add_circle_screen.dart';
import 'package:student_platform/features/auth/presentation/screens/login_screen.dart';
import 'package:student_platform/core/services/auth_service.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_bloc.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_event.dart';
import 'package:student_platform/features/admin/student/presentation/bloc/student_bloc.dart';
import 'package:student_platform/features/admin/teacher/presentation/bloc/teacher_bloc.dart';
import 'package:student_platform/features/admin/circle/presentation/bloc/circle_bloc.dart';
import 'package:student_platform/features/admin/archive/archive_exercise_cubit.dart';
import 'package:student_platform/features/admin/archive/archive_question_cubit.dart';
import 'package:student_platform/di/injection_container.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await sl<AuthService>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final List<_AdminAction> actions = [
      _AdminAction('إضافة درس', Icons.menu_book_outlined, const AddLessonScreen()),
      _AdminAction(
        'إضافة تمرين',
        Icons.add_chart,
        BlocProvider(
          create: (_) => sl<AdminExerciseBloc>(),
          child: const AddExerciseScreen(),
        ),
      ),
      _AdminAction(
        'إضافة طالب',
         Icons.person_add_alt_1, 
         BlocProvider(
          create: (_) => sl<StudentBloc>(),
          child: const AddStudentScreen(),
        ),),
      _AdminAction(
        'إضافة معلم',
        Icons.person_outline,
        BlocProvider(
          create: (_) => sl<TeacherBloc>(),
          child: const AddTeacherScreen(),
        ),
      ),
      _AdminAction(
        'إضافة  حلقة',
        Icons.person_outline,
        BlocProvider(
          create: (_) => sl<CircleBloc>(),
          child: const AddCircleScreen(),
        ),
      ),
      _AdminAction(
        'أرشفة تمرين',
        Icons.archive_outlined,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AdminExerciseBloc>()..add(FetchLessons())),
            BlocProvider(create: (_) => ArchiveExerciseCubit()),
            BlocProvider(create: (_) => ArchiveQuestionCubit()),
          ],
          child: const ArchiveExerciseScreen(),
        ),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FA),
        appBar: AppBar(
          title: const Text('لوحة تحكم المشرف'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: actions
                .map((action) => _AdminCard(
                      title: action.title,
                      icon: action.icon,
                      onTap: () => _navigate(context, action.screen),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _AdminAction {
  final String title;
  final IconData icon;
  final Widget screen;

  const _AdminAction(this.title, this.icon, this.screen);
}

class _AdminCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: Colors.teal),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
