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

void showTaskActions(Task task) {

  showModalBottomSheet(
    context: context,

    builder: (context) {

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("To Done!"),

              onTap: () {

                setState(() {
                  task.status = TaskStatus.done;
                });

                Navigator.pop(context);
              },
            ),


            ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: const Text("To-Morrow"),

              onTap: () {

                setState(() {
                  task.status = TaskStatus.tomorrow;
                });

                Navigator.pop(context);
              },
            ),


            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("To Trash"),

              onTap: () {

                setState(() {
                  task.status = TaskStatus.trash;
                });

                Navigator.pop(context);
              },
            ),

          ],
        ),
      );

    },
  );

}
  @override
  Widget build(BuildContext context) {

    final todayTasks = tasks
    .where((task) => task.status == TaskStatus.today)
    .toList();

final tomorrowTasks = tasks
    .where((task) => task.status == TaskStatus.tomorrow)
    .toList();

final completedTasks = tasks
    .where((task) => task.status == TaskStatus.done)
    .toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo ToDay"),
      ),

       body: ListView(
  padding: const EdgeInsets.all(16),

  children: [

    const Text(
      "Today",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),

    for (final task in todayTasks)

      ListTile(
        leading: const Icon(Icons.circle_outlined),
        title: Text(task.title),

        onTap: () {
          showTaskActions(task);
        },
      ),


    const SizedBox(height: 25),


    const Text(
      "Tomorrow",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),


    for (final task in tomorrowTasks)

      ListTile(
        leading: const Icon(Icons.arrow_forward),
        title: Text(task.title),

        onTap: () {
          showTaskActions(task);
        },
      ),



    const SizedBox(height: 25),


    const Text(
      "Completed",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),


    for (final task in completedTasks)

      ListTile(
        leading: const Icon(Icons.check_circle),
        title: Text(
          task.title,

          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),

        onTap: () {
          showTaskActions(task);
        },
      ),

  ],
),
    );
  }
}