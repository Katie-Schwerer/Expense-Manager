import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String projectId = '';
  String taskId = '';
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(padding: const EdgeInsets.all(16.0),
         child: Column(
          children: <Widget>[
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                return DropdownButtonFormField<String>(
                  value: projectId.isNotEmpty ? projectId : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      projectId = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Project'),
                  items: provider.project.map<DropdownMenuItem<String>>((Project project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                );
              },
            ),
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                return DropdownButtonFormField<String>(
                  value: projectId.isNotEmpty ? projectId : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      projectId = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Task'),
                  items: provider.task.map<DropdownMenuItem<String>>((Task task) {
                    return DropdownMenuItem<String>(
                      value: task.id,
                      child: Text(task.name),
                    );
                  }).toList(),
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Total Time (hours)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total time';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => totalTime = double.parse(value!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notes'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some notes';
                }
                return null;
              },
              onSaved: (value) => notes = value!,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Provider.of<TimeEntryProvider>(context, listen: false)
                      .addTimeEntry(TimeEntry(
                    id: DateTime.now().toString(), // Simple ID generation
                    projectId: projectId,
                    taskId: taskId,
                    totalTime: totalTime,
                    date: date,
                    notes: notes,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    ),
    );
  }
}

