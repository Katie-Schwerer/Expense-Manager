import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../screens/add_time_entry_screen.dart';
import '../screens/project_management_screen.dart';
import '../screens/task_management_screen.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'All Entries'),
            Tab(text: 'Grouped by Projects'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Manage Tasks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Manage Projects'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAllEntriesTab(),
          buildGroupedByProjectsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
        ),
        tooltip: 'Add Time Entry',
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget buildAllEntriesTab() {
    return Consumer<TimeEntryProvider>(
      builder: (context, timeEntryProvider, child) {
        final timeEntries = timeEntryProvider.entries;
        if (timeEntries.isEmpty) {
          return const Center(child: Text('No time entries found.'));
        }
        return ListView.builder(
          itemCount: timeEntries.length,
          itemBuilder: (context, index) {
            final entry = timeEntries[index];
            return ListTile(
              title: Text('${getProjectNameById(entry.projectId, context)} - ${getTaskNameById(entry.taskId, context)}'),
              subtitle: Text('Total Time: ${entry.totalTime} hours'
                  '\nDate: ${DateFormat.yMMMd().format(entry.date)}'
                  '\nNotes: ${entry.notes}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  timeEntryProvider.deleteTimeEntry(entry.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildGroupedByProjectsTab() {
    return Consumer<TimeEntryProvider>(
      builder: (context, timeEntryProvider, child) {
        final timeEntries = timeEntryProvider.entries;
        if (timeEntries.isEmpty) {
          return const Center(child: Text('No time entries found.'));
        }

        // Group entries by projectId
        final groupedEntries = groupBy(timeEntries, (TimeEntry entry) => entry.projectId);

        return ListView(
          children: groupedEntries.entries.map((group) {
            final projectId = group.key;
            final entries = group.value;
            final projectName = getProjectNameById(projectId, context);

            return ExpansionTile(
              title: Text(projectName),
              children: entries.map((entry) {
                return ListTile(
                  title: Text('${getTaskNameById(entry.taskId, context)}'),
                  subtitle: Text('Total Time: ${entry.totalTime} hours'
                      '\nDate: ${DateFormat.yMMMd().format(entry.date)}'
                      '\nNotes: ${entry.notes}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      timeEntryProvider.deleteTimeEntry(entry.id);
                    },
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }

  String getProjectNameById(String projectId, BuildContext context) {
    var project = Provider.of<TimeEntryProvider>(context, listen: false).project.firstWhere((proj) => proj.id == projectId);
    return project.name;
  }

  String getTaskNameById(String taskId, BuildContext context) {
    var task = Provider.of<TimeEntryProvider>(context, listen: false).task.firstWhere((tsk) => tsk.id == taskId);
    return task.name;
  }
}
