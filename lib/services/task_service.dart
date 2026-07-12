import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskService {
  static const String _boxName = 'tasks';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  List<Task> loadTasks() {
    final box = Hive.box(_boxName);

    return box.values
        .map((item) => Task.fromMap(Map<dynamic, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box(_boxName);

    await box.clear();

    for (final task in tasks) {
      await box.put(task.id, task.toMap());
    }
  }
}