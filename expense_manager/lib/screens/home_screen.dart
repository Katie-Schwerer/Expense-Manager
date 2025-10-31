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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
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
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No time entries yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your time by adding your first entry',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTimeEntryScreen()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Time Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tip: Use the menu to manage projects and tasks first',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: timeEntries.length,
          itemBuilder: (context, index) {
            final entry = timeEntries[index];
            return ListTile(
              title: Text(
                  '${getProjectNameById(entry.projectId, context)} - ${getTaskNameById(entry.taskId, context)}'),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No time entries yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your time by adding your first entry',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTimeEntryScreen()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Time Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tip: Use the menu to manage projects and tasks first',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Group entries by projectId
        final groupedEntries =
            groupBy(timeEntries, (TimeEntry entry) => entry.projectId);

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
    var project = Provider.of<TimeEntryProvider>(context, listen: false)
        .project
        .firstWhere((proj) => proj.id == projectId);
    return project.name;
  }

  String getTaskNameById(String taskId, BuildContext context) {
    var task = Provider.of<TimeEntryProvider>(context, listen: false)
        .task
        .firstWhere((tsk) => tsk.id == taskId);
    return task.name;
  }
}
