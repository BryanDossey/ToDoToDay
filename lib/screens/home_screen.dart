import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  final List<Task> tasks = [
    Task(
      id: "1",
      title: "Buy groceries",
      status: TaskStatus.today,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    ),

    Task(
      id: "2",
      title: "Call dentist",
      status: TaskStatus.today,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  ];


  @override
  Widget build(BuildContext context) {

    final todayTasks =
        tasks.where((task) => task.status == TaskStatus.today).toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo ToDay"),
      ),

      body: ListView.builder(
        itemCount: todayTasks.length,

        itemBuilder: (context, index) {

          final task = todayTasks[index];

          return ListTile(
            title: Text(task.title),
          );

        },
      ),
    );
  }
}