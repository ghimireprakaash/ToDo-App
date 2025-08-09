import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();

    taskBox = Hive.box<Task>('tasks');
  }

  // List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      taskBox.add(task);
    });
  }

  void _editTask(Task updatedTask, int index) {
    setState(() {
      taskBox.putAt(index, updatedTask);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      taskBox.deleteAt(index);
    });
  }

  void _navigateToEditScreen(Task task, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(task: task, isEditing: true),
      ),
    );

    if (result != null && result is Task) {
      _editTask(result, index);
    }
  }

  Future<void> _confirmDelete(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteTask(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📑 ToDo')),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          final tasks = box.values.toList();

          if (tasks.isEmpty) {
            return Center(child: Text('No tasks yet! Tap + to add one.'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskCard(
                task: task,
                onEdit: () => _navigateToEditScreen(task, index),
                onDelete: () => _confirmDelete(index),
              );
            },
          );
        },
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
