import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final bool isEditing;

  const AddTaskScreen({super.key, this.task, this.isEditing = false});

  @override
  State<StatefulWidget> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.task != null) {
      _titleController.text = widget.task!.title;
      _contentController.text = widget.task!.content;
    }
  }

  void _storeTask() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      final newTask = Task(title: title, content: content);

      Navigator.pop(context, newTask);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Both fields are required')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Task Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _storeTask,
              child: Text(widget.isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
