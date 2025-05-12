import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_answer.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_exercise.dart';
import 'package:student_platform/features/admin/exercise/domain/entities/admin_question.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_bloc.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_event.dart';
import 'package:student_platform/features/admin/exercise/presentation/bloc/admin_exercise_state.dart';
import 'package:student_platform/features/admin/lesson/domain/entities/admin_lesson.dart';
import 'package:student_platform/features/admin/lesson/data/models/admin_lesson_model.dart';
import 'package:student_platform/features/admin/screens/admin_home_screen.dart';
import 'package:student_platform/core/api/api_service.dart';
import 'package:student_platform/di/injection_container.dart';

class AddExerciseScreen extends StatefulWidget {
  final int? lessonId;
  const AddExerciseScreen({super.key, this.lessonId});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController titleController = TextEditingController();
  List<AdminLesson> allLessons = [];
  int? selectedLessonId;
  String? selectedType = 'اختر الإجابة الصحيحة';

  final List<AdminQuestion> questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.lessonId != null) {
      selectedLessonId = widget.lessonId;
    } else {
      _fetchLessons();
    }
    _addInitialQuestion();
  }

  Future<void> _fetchLessons() async {
    final response = await sl<ApiService>().get('/lessons'); // or your endpoint
    setState(() {
      allLessons = (response as List).map((l) => AdminLessonModel.fromJson(l)).toList();
      if (allLessons.isNotEmpty) {
        selectedLessonId = allLessons.first.id; // default selection
      }
    });
  }

  void _addInitialQuestion() {
    setState(() {
      questions.add(
        AdminQuestion(
          text: '',
          answers: selectedType == 'اختر الإجابة الصحيحة'
              ? [
                  AdminAnswer(text: '', isCorrect: true),
                  AdminAnswer(text: '', isCorrect: false),
                ]
              : [
                  AdminAnswer(text: 'صحيح', isCorrect: true),
                  AdminAnswer(text: 'خطأ', isCorrect: false),
                ],
        ),
      );
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 150,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addQuestion() {
    setState(() {
      questions.add(
        AdminQuestion(
          text: '',
          answers: selectedType == 'اختر الإجابة الصحيحة'
              ? [
                  AdminAnswer(text: '', isCorrect: true),
                  AdminAnswer(text: '', isCorrect: false),
                ]
              : [
                  AdminAnswer(text: 'صحيح', isCorrect: true),
                  AdminAnswer(text: 'خطأ', isCorrect: false),
                ],
        ),
      );
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 150,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  void _updateCorrectAnswer(int questionIndex, int selectedIndex) {
    for (int i = 0; i < questions[questionIndex].answers.length; i++) {
      questions[questionIndex].answers[i].isCorrect = (i == selectedIndex);
    }
  }

  void _submit() {

    if (!_formKey.currentState!.validate()) return;

    final isValid = questions.every((q) => q.answers.any((a) => a.isCorrect));
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كل سؤال يجب أن يحتوي على إجابة صحيحة واحدة على الأقل')),
      );
      return;
    }

    final exercise = AdminExercise(
      lessonId: selectedLessonId!,
      title: titleController.text.trim(),
      type: selectedType!,
      questions: questions,
    );
    print(exercise);
    context.read<AdminExerciseBloc>().add(SubmitExercise(exercise));
  }

  Widget _buildQuestionCard(int index, AdminQuestion question) {
    return Card(
      color: Colors.white,
      key: ValueKey(question), // ✅ Use stable key for proper reorder behavior
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      
                      initialValue: question.text,
                      decoration: InputDecoration(
                        labelText: 'السؤال',
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
                      onChanged: (val) => question.text = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'أدخل نص السؤال' : null,
                    ),
                  ),
                  if (questions.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeQuestion(index),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              ...question.answers.asMap().entries.map((entry) {
                final aIndex = entry.key;
                final answer = entry.value;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextFormField(
                    readOnly: selectedType != 'اختر الإجابة الصحيحة',
                    initialValue: answer.text,
                    decoration: InputDecoration(
                      labelText: 'إجابة',
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
                    onChanged: (val) => answer.text = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'أدخل نص الإجابة' : null,
                  ),
                  leading: Radio<int>(
                    value: aIndex,
                    groupValue: question.answers.indexWhere((a) => a.isCorrect),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _updateCorrectAnswer(index, val));
                      }
                    },
                  ),
                  trailing: (selectedType == 'اختر الإجابة الصحيحة' &&
                          question.answers.length > 2 &&
                          aIndex >= 2)
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              question.answers.removeAt(aIndex);
                            });
                          },
                        )
                      : null,
                );
              }).toList(),
              if (selectedType == 'اختر الإجابة الصحيحة' &&
                  question.answers.length < 4)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        question.answers.add(AdminAnswer(text: '', isCorrect: false));
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة إجابة'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(title: const Text('إضافة تمرين'), backgroundColor: Colors.teal,
          foregroundColor: Colors.white,),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: _addQuestion,
            label: const Text('إضافة سؤال'),
            icon: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<AdminExerciseBloc, AdminExerciseState>(
              listener: (context, state) {
                if (state is ExerciseSuccess) {
                  print("State is success");
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green, size: 64),
                          SizedBox(height: 16),
                          Text('تمت إضافة التمرين بنجاح'),
                        ],
                      ),
                    ),
                  );
                 Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                        (_) => false,
                      ); // close screen
                    });
                } else if (state is ExerciseFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (widget.lessonId == null)
                        DropdownButtonFormField<int>(
                          value: selectedLessonId,
                          items: allLessons
                              .map((lesson) => DropdownMenuItem(
                                    value: lesson.id,
                                    child: Text(lesson.title),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => selectedLessonId = val),
                          decoration: InputDecoration(
                            labelText: 'اختر الدرس',
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
                          validator: (val) => val == null ? 'يجب اختيار درس' : null,
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'نوع التمرين',
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
                        validator: (val) => val == null || val.isEmpty ? 'أدخل عنوان التمرين' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        items: const [
                          DropdownMenuItem(value: 'اختر الإجابة الصحيحة', child: Text('اختر الإجابة الصحيحة')),
                          DropdownMenuItem(value: 'صحيح أم خطأ', child: Text('صحيح أم خطأ')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'نوع التمرين',
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
                        onChanged: (val) {
                          if (val != null && val != selectedType) {
                            setState(() {
                              selectedType = val;
                              questions.clear();
                              questions.add(
                                AdminQuestion(
                                  text: '',
                                  answers: selectedType == 'اختر الإجابة الصحيحة'
                                      ? [
                                          AdminAnswer(text: '', isCorrect: true),
                                          AdminAnswer(text: '', isCorrect: false),
                                        ]
                                      : [
                                          AdminAnswer(text: 'صحيح', isCorrect: true),
                                          AdminAnswer(text: 'خطأ', isCorrect: false),
                                        ],
                                ),
                              );
                            });

                            Future.delayed(const Duration(milliseconds: 200), () {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent + 150,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ReorderableListView(
                          scrollController: _scrollController, // ✅ Correct
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex--;
                              final item = questions.removeAt(oldIndex);
                              questions.insert(newIndex, item);
                            });
                          },
                          children: [
                            for (int i = 0; i < questions.length; i++)
                              _buildQuestionCard(i, questions[i]),
                          ],
                        ),
                      ),
                      if (questions.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: state is ExerciseLoading ? null : _submit,
                          icon: state is ExerciseLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            state is ExerciseLoading ? '' : 'إرسال التمرين',
                          ),
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