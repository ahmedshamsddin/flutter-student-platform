import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/core/api/api_service.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/admin/student/domain/entities/student.dart';
import 'package:student_platform/features/admin/student/presentation/bloc/student_bloc.dart';
import 'package:student_platform/features/admin/student/presentation/bloc/student_event.dart';
import 'package:student_platform/features/admin/student/presentation/bloc/student_state.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  int? selectedCircleId;
  List<Map<String, dynamic>> circles = [];

  @override
  void initState() {
    super.initState();
    _fetchCircles();
  }

  Future<void> _fetchCircles() async {
    final response = await sl<ApiService>().get('/circles');
    setState(() {
      circles = List<Map<String, dynamic>>.from(response);
      if (circles.isNotEmpty) selectedCircleId = circles.first['id'];
    });
  }

  void _submit() {
    print("Submitting form");
    if (!_formKey.currentState!.validate()) return;

    final student = Student(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      circleId: selectedCircleId!,
    );
    print(student);
    context.read<StudentBloc>().add(SubmitStudent(student));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(title: const Text('إضافة طالب'),backgroundColor: Colors.teal,
          foregroundColor: Colors.white,),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<StudentBloc, StudentState>(
              listener: (context, state) {
                if (state is StudentSuccess) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('نجاح'),
                      content: const Text('تمت إضافة الطالب بنجاح'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('حسناً'),
                        )
                      ],
                    ),
                  );
                } else if (state is StudentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                        labelText: 'اسم الطالب',
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
                        validator: (val) => val == null || val.isEmpty ? 'الاسم مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,

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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: selectedCircleId,
                        items: circles
                            .map((c) => DropdownMenuItem<int>(
                              value: c['id'] as int,
                              child: Text(c['name'] as String),
                            ))
                        .toList(),
                        onChanged: (val) => setState(() => selectedCircleId = val),
                        decoration: InputDecoration(
                          labelText: 'اختر الحلقة',
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
                        validator: (val) => val == null ? 'يجب اختيار حلقة' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          print(state);
                          if (state is! StudentLoading) _submit();
                        },
                        icon: const Icon(Icons.person_add_alt),
                        label: state is StudentLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('إضافة الطالب'),
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
                );
              },
            ),
          ),
        ),
      );
  }
}
