import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ToDoToDayApp());
}


class ToDoToDayApp extends StatelessWidget {

  const ToDoToDayApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "ToDo ToDay",

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}