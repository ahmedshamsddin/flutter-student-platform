import 'package:flutter/material.dart';
import 'package:student_platform/features/auth/presentation/screens/login_screen.dart';
import 'package:student_platform/features/admin/screens/admin_home_screen.dart';
import 'package:student_platform/features/student/lesson/presentation/screens/lesson_list_screen.dart';
import 'package:student_platform/core/services/auth_service.dart';
import 'package:student_platform/di/injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = sl<AuthService>();
    final token = await auth.getToken();
    final role = await auth.getRole();
    final userId = await auth.getUserId();

    if (!mounted) return;

    if (token == null || role == null || userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    if (role == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonListScreen(studentId: userId),
        ),
      );
    } else if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      );
    } else {
      // fallback in case role is corrupted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
