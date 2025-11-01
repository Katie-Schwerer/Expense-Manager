import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/time_entry.dart';
import '../models/task.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of Time Entry
  List<TimeEntry> _entries = [];

  // List of project
  List<Project> _projects = [
    Project(id: '1', name: "Project Alpha"),
    Project(id: '2', name: "Project Beta"),
    Project(id: '3', name: "Project Gamma"),
  ];

  List<Task> _task = [
    Task(id: '1', name: "Task A"),
    Task(id: '2', name: "Task B"),
    Task(id: '3', name: "Task C")
  ];

  List<TimeEntry> get entries => _entries;
  List<Project> get project => _projects;
  List<Task> get task => _task;

  TimeEntryProvider(this.storage) {
    _loadTimeEntryProviderFromStorage();
  }

  void _loadTimeEntryProviderFromStorage() async {
    var storedExtries = storage.getItem('time_entries');
    if (storedExtries != null) {
      _entries = List<TimeEntry>.from(
          (storedExtries as List).map((item) => TimeEntry.fromJson(item)));
    }
    var storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      _projects = List<Project>.from(
          (storedProjects as List).map((item) => Project.fromJson(item)));
    }
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _task = List<Task>.from(
          (storedTasks as List).map((item) => Task.fromJson(item)));
    }
    notifyListeners();
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntryProviderToStorage();
    notifyListeners();
  }

  void _saveTimeEntryProviderToStorage() {
    storage.setItem(
        'time_entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryProviderToStorage();
    notifyListeners();
  }

  void updateTimeEntry(TimeEntry updatedEntry) {
    int index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      _saveTimeEntryProviderToStorage();
      notifyListeners();
    }
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addTask(Task task) {
    _task.add(task);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void deleteTask(String id) {
    _task.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void removeTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryProviderToStorage();
    notifyListeners();
  }
}
