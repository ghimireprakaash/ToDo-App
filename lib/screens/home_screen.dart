import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📑 ToDo')),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet! Tap + to add one.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskCard(task: tasks[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );

          if (result != null && result is Task) {
            _addTask(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
