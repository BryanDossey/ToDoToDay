enum TaskStatus {
  active,
  done,
  trash,
}

class Task {
  final String id;
  String title;

  DateTime date;

  TaskStatus status;

  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.createdAt,
  });
}