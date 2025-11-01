import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/time_entry_provider.dart';
import '../widget/add_task_dialog.dart';

/// A screen that manages tasks and their associated time entries.
class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.task.length,
            itemBuilder: (context, index) {
              final task = provider.task[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    provider.deleteTimeEntry(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AddTaskDialog(
                    onTaskAdded: (newTask) {
                      Provider.of<TimeEntryProvider>(context, listen: false)
                          .addTask(newTask);
                      Navigator.of(context).pop();
                    },
                  ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
