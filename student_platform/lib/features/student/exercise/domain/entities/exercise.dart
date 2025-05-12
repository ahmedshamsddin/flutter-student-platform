class Exercise {
  final int id;
  final int lessonId;
  final String title;
  final String type;
  final bool archived;
  final int questionCount;

  Exercise({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.type,
    required this.archived,
    required this.questionCount
  });
}
