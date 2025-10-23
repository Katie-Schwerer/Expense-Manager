import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/time_entry_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  AddTaskDialog({required this.onTaskAdded});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _taskNameController = TextEditingController();

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  void _addTask() {
    final taskName = _taskNameController.text.trim();
    if (taskName.isNotEmpty) {
      final newTask = Task(id: UniqueKey().toString(), name: taskName);
      widget.onTaskAdded(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: TextField(
        controller: _taskNameController,
        decoration: const InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addTask,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
