import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/time_entry_provider.dart';
import '../widget/add_project_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.project.length,
            itemBuilder: (context, index) {
              final project = provider.project[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    provider.deleteProject(project.id);
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
              builder: (context) => AddProjectDialog(
                    onProjectAdded: (newProject) {
                      Provider.of<TimeEntryProvider>(context, listen: false)
                          .addProject(newProject);
                      Navigator.of(context).pop();
                    },
                  ));
        },
      ),
    );
  }
}