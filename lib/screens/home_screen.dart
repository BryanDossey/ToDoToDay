import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Task> tasks = [
    Task(
      id: "1",
      title: "Buy groceries",
      date: DateTime.now(),
      status: TaskStatus.active,
      createdAt: DateTime.now(),
    ),
    Task(
      id: "2",
      title: "Call dentist",
      date: DateTime.now(),
      status: TaskStatus.active,
      createdAt: DateTime.now(),
    ),
    Task(
      id: "3",
      title: "Pay electric bill",
      date: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.active,
      createdAt: DateTime.now(),
    ),
  ];

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String dayName(DateTime date) {
  return DateFormat('EEEE').format(date);
}

String fullDate(DateTime date) {
  return DateFormat('MMMM d, yyyy').format(date);
}

  void goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
          date: selectedDate,
          status: TaskStatus.active,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void showAddTaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Task"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "What do you need to do?",
            ),
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
        );
      },
    );
  }

  void showTaskActions(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
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
                    task.date = task.date.add(const Duration(days: 1));
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
    final activeTasks = tasks.where((task) {
      return task.status == TaskStatus.active &&
          isSameDay(task.date, selectedDate);
    }).toList();

    final completedTasks = tasks.where((task) {
      return task.status == TaskStatus.done &&
          isSameDay(task.date, selectedDate);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo ToDay"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
  children: [
    Text(
      dayName(selectedDate),
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(height: 4),

    Text(
      fullDate(selectedDate),
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey.shade600,
      ),
    ),

    const SizedBox(height: 12),

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: goToPreviousDay,
          icon: const Icon(Icons.chevron_left),
        ),

        TextButton(
          onPressed: () {
            setState(() {
              selectedDate = DateTime.now();
            });
          },
          child: const Text("Today"),
        ),

        IconButton(
          onPressed: goToNextDay,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    ),
  ],
),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}