class Answer {
  final int id;
  final String text;
  final bool isCorrect; // backend-only; don't use in UI

  Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}
