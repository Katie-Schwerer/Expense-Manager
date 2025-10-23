import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
            DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (String? newValue) {
                setState(() {
                    projectId = newValue!;
                });
                },
                decoration: const InputDecoration(labelText: 'Project'),
                items: <String>['Project 1', 'Project 2', 'Project 3'] // Dummy project names
                    .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                );
                }).toList(),
            ),
            DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (String? newValue) {
                setState(() {
                    taskId = newValue!;
                });
                },
                decoration: const InputDecoration(labelText: 'Task'),
                items: <String>['Task 1', 'Task 2', 'Task 3'] // Dummy task names
                    .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                );
                }).toList(),
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
    );
  }
}

