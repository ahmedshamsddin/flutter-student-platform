import 'package:flutter/material.dart';
import 'package:student_platform/core/services/auth_service.dart';
import 'package:student_platform/features/student/lesson/presentation/screens/lesson_list_screen.dart';
import 'package:student_platform/features/admin/screens/admin_home_screen.dart'; // Create later or replace
import 'package:student_platform/di/injection_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _handleLogin() async {
    setState(() {
      loading = true;
      error = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email == '' || password == '') {
      print("true");
      setState(() {
        loading = false;
        error = 'ادخل البيانات';
      });
      return;
    }
    try {
    final auth = sl<AuthService>();
      final success = await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

/*    if (!success) {
      setState(() {
        error = 'فشل في تسجيل الدخول';
        loading = false;
      });
      return;
    }*/

    final role = await auth.getRole();

    if (!mounted) return;

    if (role == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LessonListScreen(
            studentId: 1, // Replace with real ID if stored
          ),
        ),
      );
    } else if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminHomeScreen(),
        ),
      );
    } else {
      setState(() {
        error = 'دور غير معروف';
        loading = false;
      });
    }} catch (e) {
      print(e);
      setState(() {
        error = 'فشل في تسجيل الدخول';
        loading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white,
                elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding( 
                    padding: const EdgeInsets.all(24),
                    child: Column(
                    children: [
                      const Text('تسجيل الدخول',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),

                        ),
                        validator: (val) =>
                            val == null || !val.contains('@') ? 'بريد إلكتروني غير صالح' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),

                                                  validator: (val) =>
                            val == null || val.length < 6 ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : null,
                      ),
                      const SizedBox(height: 24),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: loading ? null : _handleLogin,
                        icon: const Icon(Icons.login),
                        label: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('دخول', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        ),
                      ),
                    ],
                    ),
                  ),
              ),
                
          ),
        ),
      ),
    ));
  }
}
