import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoToDayApp());
}

class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

class ToDoToDayApp extends StatelessWidget {
  const ToDoToDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo ToDay',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
    Task("Buy groceries"),
    Task("Call dentist"),
    Task("Walk dog"),
  ];

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title));
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = tasks.where((t) => !t.isDone).toList();
    final doneTasks = tasks.where((t) => t.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo ToDay"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Today",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          for (int i = 0; i < activeTasks.length; i++)
            Card(
              child: ListTile(
                title: Text(activeTasks[i].title),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final originalIndex = tasks.indexOf(activeTasks[i]);
                    toggleTask(originalIndex);
                  },
                ),
              ),
            ),

          const SizedBox(height: 20),

          const Text(
            "Completed",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          for (final task in doneTasks)
            Card(
              color: Colors.green.withOpacity(0.2),
              child: ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("New Task"),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Task name"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}