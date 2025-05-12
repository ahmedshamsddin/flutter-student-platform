import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/core/api/api_service.dart';
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/admin/circle/domain/entities/circle.dart';
import 'package:student_platform/features/admin/circle/presentation/bloc/circle_bloc.dart';
import 'package:student_platform/features/admin/circle/presentation/bloc/circle_event.dart';
import 'package:student_platform/features/admin/circle/presentation/bloc/circle_state.dart';

class AddCircleScreen extends StatefulWidget {
  const AddCircleScreen({super.key});

  @override
  State<AddCircleScreen> createState() => _AddCircleScreenState();
}

class _AddCircleScreenState extends State<AddCircleScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  List<Map<String, dynamic>> centers = [];
  int? selectedCenterId;

  @override
  void initState() {
    super.initState();
    _fetchCenters();
  }

  Future<void> _fetchCenters() async {
    final response = await sl<ApiService>().get('/centers');
    setState(() {
      centers = (response as List).cast<Map<String, dynamic>>();
      if (centers.isNotEmpty) {
        selectedCenterId = centers.first['id'];
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final circle = Circle(
      name: nameController.text.trim(),
      centerId: selectedCenterId!,
    );

    context.read<CircleBloc>().add(SubmitCircle(circle));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7FA),
          appBar: AppBar(title: const Text('إضافة حلقة'),backgroundColor: Colors.teal,
          foregroundColor: Colors.white,),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<CircleBloc, CircleState>(
              listener: (context, state) {
                if (state is CircleSuccess) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('نجاح'),
                      content: const Text('تمت إضافة الحلقة بنجاح'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // dialog
                            Navigator.pop(context); // screen
                          },
                          child: const Text('موافق'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CircleFailure) {
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
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'اسم الحلقة',
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
                        validator: (value) =>
                            value == null || value.isEmpty ? 'الرجاء إدخال اسم الحلقة' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: selectedCenterId,
                        items: centers
                            .map((c) => DropdownMenuItem<int>(
                                  value: c['id'],
                                  child: Text(c['name']),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => selectedCenterId = val),
                        decoration: InputDecoration(
                          labelText: 'اختر المركز',
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
                        validator: (val) => val == null ? 'يجب اختيار مركز' : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: state is CircleLoading ? null : _submit,
                        icon: const Icon(Icons.send),
                        label: state is CircleLoading
                            ? const CircularProgressIndicator()
                            : const Text('إضافة الحلقة'),
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
