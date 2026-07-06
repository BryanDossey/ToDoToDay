enum TaskStatus {
  today,
  tomorrow,
  done,
  trash,
}

class Task {
  final String id;
  String title;
  TaskStatus status;
  DateTime date;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.createdAt,
  });
}