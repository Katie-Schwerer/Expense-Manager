import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../widget/add_project_dialog.dart';
import '../widget/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialEntry;

  const AddTimeEntryScreen({Key? key, this.initialEntry}) : super(key: key);

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _timeController;
  late TextEditingController _notesController;
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(
        text: widget.initialEntry != null
            ? widget.initialEntry!.totalTime.toString()
            : '');
    _notesController = TextEditingController(
        text: widget.initialEntry != null ? widget.initialEntry!.notes : '');
    _selectedProjectId = widget.initialEntry?.projectId;
    _selectedTaskId = widget.initialEntry?.taskId;
    _selectedDate = widget.initialEntry?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(_timeController, 'Total Time (hours)',
                TextInputType.numberWithOptions(decimal: true)),
            buildTextField(_notesController, 'Notes', TextInputType.text),
            buildDateField(_selectedDate),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildProjectDropdown(timeEntryProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildTaskDropdown(timeEntryProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveTimeEntry,
          child: const Text('Save Time Entry'),
        ),
      ),
    );
  }

  void _saveTimeEntry() {
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields!')),
      );
      return;
    }

    final timeEntry = TimeEntry(
      id: widget.initialEntry?.id ?? DateTime.now().toString(),
      projectId: _selectedProjectId!,
      taskId: _selectedTaskId!,
      totalTime: double.parse(_timeController.text),
      date: _selectedDate,
      notes: _notesController.text,
    );

    Provider.of<TimeEntryProvider>(context, listen: false)
        .addTimeEntry(timeEntry);
    Navigator.pop(context);
  }

  Widget buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        if (newValue == "New") {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(onProjectAdded: (newProject) {
              setState(() {
                _selectedProjectId = newProject.id;
                provider.addProject(newProject); 
              });
            }),
          );
        } else {
          setState(() {
            _selectedProjectId = newValue;
          });
        }
      },
      items: provider.project.map<DropdownMenuItem<String>>((project) {
        return DropdownMenuItem<String>(
          value: project.id,
          child: Text(project.name),
        );
      }).toList()
        ..add(
          const DropdownMenuItem<String>(
            value: "New",
            child: Text("Add New Project"),
          ),
        ),
      decoration: const InputDecoration(
        labelText: 'Project',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        if (newValue == "New") {
          // Implement similar dialog for adding new task if needed
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(onTaskAdded: (newTask) {
              setState(() {
                _selectedTaskId = newTask.id;
                provider.addTask(newTask); 
              });
            }),
          );
        } else {
          setState(() {
            _selectedTaskId = newValue;
          });
        }
      },
      items: provider.task.map<DropdownMenuItem<String>>((task) {
        return DropdownMenuItem<String>(
          value: task.id,
          child: Text(task.name),
        );
      }).toList()
        ..add(
          const DropdownMenuItem(
            value: "New",
            child: Text("Add New Task"),
          ),
        ),
      decoration: const InputDecoration(
        labelText: 'Task',
        border: OutlineInputBorder(),
      ),
    );
  }
}
