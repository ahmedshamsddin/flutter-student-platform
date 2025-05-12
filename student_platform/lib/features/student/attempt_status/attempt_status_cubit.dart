import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_platform/core/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_platform/di/injection_container.dart';
import 'dart:convert';

class AttemptStatusState {
  final Map<int, int> exerciseScores;

  AttemptStatusState({required this.exerciseScores});
}

class AttemptStatusCubit extends Cubit<AttemptStatusState> {
  AttemptStatusCubit() : super(AttemptStatusState(exerciseScores: {}));

  int? getScore(int exerciseId) {
    return state.exerciseScores[exerciseId];
  }

Future<void> loadFromBackend(int studentId) async {
  try {
    final api = sl<ApiService>();
    final response = await api.get('/attempts/latest_scores?student_id=$studentId');
    
    final parsed = (response as Map<String, dynamic>)
        .map((k, v) => MapEntry(int.parse(k), v as int));
    emit(AttemptStatusState(exerciseScores: parsed));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'attempt_scores',
      jsonEncode(parsed.map((key, value) => MapEntry(key.toString(), value))),
    );
  } catch (e) {
    print('❌ Failed to load scores from backend: $e');
  }
}


Future<void> loadFromCache(int studentId) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'attempt_scores_user_$studentId';
  final jsonString = prefs.getString(key);
  if (jsonString != null) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final parsed = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    emit(AttemptStatusState(exerciseScores: parsed));
  }
}

Future<void> updateScore(int studentId, int exerciseId, int score) async {
  final updated = Map<int, int>.from(state.exerciseScores);
  updated[exerciseId] = score;
  emit(AttemptStatusState(exerciseScores: updated));
  final prefs = await SharedPreferences.getInstance();
  final key = 'attempt_scores_user_$studentId';
  await prefs.setString(
    key,
    jsonEncode(updated.map((k, v) => MapEntry(k.toString(), v))),
  );
}

}
