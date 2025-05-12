import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/lesson/presentation/bloc/lesson_admin_bloc.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_bloc.dart';
import 'package:student_platform/features/admin/lesson/presentation/bloc/lesson_admin_event.dart';
import 'package:student_platform/features/admin/lesson/presentation/bloc/lesson_admin_state.dart';
import 'package:student_platform/features/admin/exercise/presentation/screens/add_exercise_screen.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/institute.dart';
import 'package:student_platform/features/admin/lesson/data/models/institute_model.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/core/api/api_service.dart';


class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final titleController = TextEditingController();
  int? selectedInstituteId;
  List<Institute> institutes = [];

  @override
  void initState() {
    super.initState();
    _fetchInstitutes();
  }

  Future<void> _fetchInstitutes() async {
    final response = await sl<ApiService>().get('/institutes');

    setState(() {
      institutes = (response as List)
          .map((json) => InstituteModel.fromJson(json))
          .toList();
      if (institutes.isNotEmpty) {
        selectedInstituteId = institutes.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LessonAdminBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(title: const Text('إضافة درس'),backgroundColor: Colors.teal,
          foregroundColor: Colors.white,),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<LessonAdminBloc, LessonAdminState>(
              listener: (context, state) {
                if (state is LessonSuccess) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('تم بنجاح'),
                      content: Text('تمت إضافة الدرس: ${state.lesson.title}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => sl<AdminExerciseBloc>(),
                                  child: AddExerciseScreen(lessonId: state.lesson.id),
                                ),
                              ),
                            );
                          },
                          child: const Text('حسناً'),
                        )
                      ],
                    ),
                  );
                } else if (state is LessonFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان الدرس',
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
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: selectedInstituteId,
                      items: institutes
                          .map((i) => DropdownMenuItem<int>(
                                value: i.id,
                                child: Text(i.name),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'اختر المعهد',
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
                      onChanged: (value) => setState(() => selectedInstituteId = value),
                    ),
                    const SizedBox(height: 20),
                    if (state is LessonFailure)
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                    ElevatedButton.icon(
                      onPressed: state is LessonLoading
                          ? null
                          : () {
                              final title = titleController.text.trim();
                              if (title.isNotEmpty && selectedInstituteId != null) {
                                context.read<LessonAdminBloc>().add(
                                      SubmitLesson(title, selectedInstituteId!),
                                    );
                              }
                            },
                      icon: state is LessonLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(state is LessonLoading ? '' : 'إضافة الدرس'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                    ),
                    ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
