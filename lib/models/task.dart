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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: TaskStatus.values.firstWhere(
        (status) => status.name == map['status'],
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}