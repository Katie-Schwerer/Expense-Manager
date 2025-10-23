import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/time_entry_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onProjectAdded;

  AddProjectDialog({required this.onProjectAdded});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _projectNameController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }

  void _addProject() {
    final projectName = _projectNameController.text.trim();
    if (projectName.isNotEmpty) {
      final newProject = Project(id: UniqueKey().toString(), name: projectName);
      widget.onProjectAdded(newProject);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Project'),
      content: TextField(
        controller: _projectNameController,
        decoration: const InputDecoration(labelText: 'Project Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addProject,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
