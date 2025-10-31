import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

import '../providers/time_entry_provider.dart';
import '../screens/home_screen.dart';
import '../screens/add_time_entry_screen.dart';
import '../screens/task_management_screen.dart';
import '../screens/project_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add_time_entry': (context) => AddTimeEntryScreen(),
          '/manage_tasks': (context) => TaskManagementScreen(),
          '/manage_projects': (context) => ProjectManagementScreen(),
        },
      ),
    );
  }
}
