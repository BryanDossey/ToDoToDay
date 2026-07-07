import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_card.dart';

enum CalendarView {
  day,
  week,
  month,
}

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({
    super.key,
    required this.taskService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  CalendarView currentView = CalendarView.day;
  final Set<String> completingTaskIds = {};
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() {
    final savedTasks = widget.taskService.loadTasks();

    setState(() {
      if (savedTasks.isEmpty) {
        tasks = [
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

        saveTasks();
      } else {
        tasks = savedTasks;
      }
    });
  }

  void saveTasks() {
    widget.taskService.saveTasks(tasks);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String dayName(DateTime date) => DateFormat('EEEE').format(date);

  String fullDate(DateTime date) => DateFormat('MMMM d, yyyy').format(date);

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

  void goToToday() {
    setState(() {
      selectedDate = DateTime.now();
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

    saveTasks();
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
Future<void> showToSoonOptions(Task task) async {
  Navigator.pop(context);

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "To Soon...",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: const Text("Tomorrow"),
              onTap: () {
                setState(() {
                  task.date = selectedDate.add(const Duration(days: 1));
                });
                saveTasks();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text("Later This Week"),
              onTap: () {
                setState(() {
                  task.date = selectedDate.add(const Duration(days: 3));
                });
                saveTasks();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.next_week),
              title: const Text("Next Week"),
              onTap: () {
                setState(() {
                  task.date = selectedDate.add(const Duration(days: 7));
                });
                saveTasks();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Pick a Date..."),
              onTap: () async {
                Navigator.pop(context);

                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: task.date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (pickedDate == null) return;

                setState(() {
                  task.date = pickedDate;
                });

                saveTasks();
              },
            ),
          ],
        ),
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
                  Navigator.pop(context);

                  setState(() {
                    completingTaskIds.add(task.id);
                  });

                  Future.delayed(const Duration(milliseconds: 450), () {
                    if (!mounted) return;

                    setState(() {
                      task.status = TaskStatus.done;
                      completingTaskIds.remove(task.id);
                    });

                    saveTasks();
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward),
                title: const Text("To-Morrow"),
                onTap: () {
                  setState(() {
                    task.date = task.date.add(const Duration(days: 1));
                  });

                  saveTasks();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("To Soon..."),
                onTap: () {
                  showToSoonOptions(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("To Trash"),
                onTap: () {
                  setState(() {
                    task.status = TaskStatus.trash;
                  });

                  saveTasks();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

 Widget buildDayView() {
  final activeTasks = tasks.where((task) {
    return task.status == TaskStatus.active &&
        isSameDay(task.date, selectedDate);
  }).toList();

  final completedTasks = tasks.where((task) {
    return task.status == TaskStatus.done &&
        isSameDay(task.date, selectedDate);
  }).toList();

  return ListView(
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
                  PopupMenuButton<CalendarView>(
                    initialValue: currentView,
                    onSelected: (view) {
                      setState(() {
                        currentView = view;
                      });
                    },
                    child: Text(
                      currentView == CalendarView.day
                      ? "Day View"
                      : currentView == CalendarView.week
                        ? "Week View"
                        : "Month View"
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: CalendarView.day,
                        child: Text("Day View"),
                      ),
                      PopupMenuItem(
                        value: CalendarView.week,
                        child: Text("Week View"),
                      ),
                      PopupMenuItem(
                        value: CalendarView.month,
                        child: Text("Month View"),
),
                  ],
                ),
                  IconButton(
                    onPressed: goToNextDay,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Today's Focus",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (activeTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Nothing scheduled. Enjoy your day."),
            ),
          for (final task in activeTasks)
            TaskCard(
              title: task.title,
              icon: Icons.circle_outlined,
              isCompleting: completingTaskIds.contains(task.id),
              onTap: () => showTaskActions(task),
            ),
          if (completedTasks.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              "Done Today",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            for (final task in completedTasks)
              TaskCard(
                title: task.title,
                icon: Icons.check_circle,
                isCompleted: true,
                onTap: () => showTaskActions(task),
              ),
            ],
        ]
        );
    } 
  Widget buildWeekView() {
  final startOfWeek =
      selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

  final weekDays = List.generate(
    7,
    (index) => startOfWeek.add(Duration(days: index)),
  );
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: weekDays.length,
    itemBuilder: (context, index) {
      final day = weekDays[index];

      final taskCount = tasks.where((task) {
        return task.status == TaskStatus.active &&
            isSameDay(task.date, day);
      }).length;

      return Card(
        child: ListTile(
          title: Text(
            DateFormat('EEEE').format(day),
          ),
          subtitle: Text(
            DateFormat('MMMM d').format(day),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              taskCount,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Icon(
                  Icons.circle,
                  size: 8,
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              selectedDate = day;
              currentView = CalendarView.day;
            });
          },
        ),
      );
    },
  );
}
Widget buildMonthView() {
  return const Center(
    child: Text(
      "Month View Coming Soon",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
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
      body: currentView == CalendarView.day
    ? buildDayView()
    : currentView == CalendarView.week
        ? buildWeekView()
        : buildMonthView(),
          
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}