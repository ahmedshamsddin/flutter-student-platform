import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/teacher/domain/entities/teacher.dart';
import 'package:student_platform/features/admin/teacher/presentation/bloc/teacher_bloc.dart';
import 'package:student_platform/features/admin/teacher/presentation/bloc/teacher_event.dart';
import 'package:student_platform/features/admin/teacher/presentation/bloc/teacher_state.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/core/api/api_service.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
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
    final response = await sl<ApiService>().get('/circles/available');
    setState(() {
      circles = List<Map<String, dynamic>>.from(response);
      if (circles.isNotEmpty) selectedCircleId = circles.first['id'];
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final teacher = Teacher(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      circleId: selectedCircleId!,
    );

    context.read<TeacherBloc>().add(SubmitTeacher(teacher));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeacherBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(title: const Text('إضافة معلم'),backgroundColor: Colors.teal,
          foregroundColor: Colors.white,),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TeacherBloc, TeacherState>(
              listener: (context, state) {
                if (state is TeacherSuccess) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('تم بنجاح'),
                      content: const Text('تمت إضافة المعلم بنجاح'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // go back
                          },
                          child: const Text('حسناً'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TeacherFailure) {
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
                          labelText: 'الاسم',
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
                            val == null || val.isEmpty ? 'الرجاء إدخال الاسم' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                          decoration: InputDecoration(
                          labelText:  'البريد الإلكتروني',
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
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val == null || !val.contains('@') ? 'بريد غير صالح' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
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
                        obscureText: true,
                        validator: (val) =>
                            val == null || val.length < 6 ? '6 أحرف على الأقل' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: selectedCircleId,
                        items: circles
                            .map((circle) => DropdownMenuItem<int>(
                                  value: circle['id'],
                                  child: Text(circle['name']),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => selectedCircleId = val),
                          decoration: InputDecoration(
                          labelText:'اختر الحلقة',
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
                        validator: (val) => val == null ? 'اختر حلقة' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: state is TeacherLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('إضافة المعلم'),
                        onPressed: state is TeacherLoading
                            ? null
                            : () => _submit(context),
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
      ),
    );
  }
}