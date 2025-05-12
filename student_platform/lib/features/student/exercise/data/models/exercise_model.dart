import '../../domain/entities/exercise.dart';

class ExerciseModel extends Exercise {
  ExerciseModel({
    required int id,
    required int lessonId,
    required String title,
    required String type,
    required bool archived,
    required int questionCount,
  }) : super(
          id: id,
          lessonId: lessonId,
          title: title,
          type: type,
          archived: archived,
          questionCount: questionCount,
        );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      title: json['title'],
      type: json['type'],
      archived: json['archived'],
      questionCount: int.parse(json['question_count'].toString()),
    );
  }
}
