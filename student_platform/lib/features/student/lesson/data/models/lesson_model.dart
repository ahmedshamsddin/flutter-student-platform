import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  LessonModel({required int id, required String title})
      : super(id: id, title: title);

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
