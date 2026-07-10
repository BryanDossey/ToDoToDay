import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/task_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskService = TaskService();
  await taskService.init();

  runApp(ToDoToDayApp(taskService: taskService));
}

class ToDoToDayApp extends StatelessWidget {
  final TaskService taskService;

  const ToDoToDayApp({
    super.key,
    required this.taskService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo ToDay",
      theme: AppTheme.lightTheme,
      home: HomeScreen(taskService: taskService),
    );
  }
}