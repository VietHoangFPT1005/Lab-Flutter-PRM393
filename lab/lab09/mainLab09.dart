// Lab 9 – Working With Local JSON Storage
// Covers: rootBundle (assets), path_provider, dart:convert, CRUD operations
//
// Sub-tasks:
//   Lab 9.1 – Read JSON from assets (rootBundle)
//   Lab 9.2 – Save & Load JSON from device storage (path_provider)
//   Lab 9.3 – JSON CRUD Mini Database (add, edit, delete, search)

import 'package:flutter/material.dart';
import 'screens/lab91_screen.dart';
import 'screens/lab92_screen.dart';
import 'screens/lab93_screen.dart';

void main() {
  runApp(const Lab09App());
}

class Lab09App extends StatelessWidget {
  const Lab09App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local JSON Storage – Lab 9',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Lab09Home(),
    );
  }
}

class Lab09Home extends StatefulWidget {
  const Lab09Home({super.key});

  @override
  State<Lab09Home> createState() => _Lab09HomeState();
}

class _Lab09HomeState extends State<Lab09Home> {
  int _currentTab = 0;

  final List<Widget> _screens = const [
    Lab91Screen(),
    Lab92Screen(),
    Lab93Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentTab, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (i) => setState(() => _currentTab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open),
            label: '9.1 Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.save),
            label: '9.2 Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage),
            label: '9.3 CRUD',
          ),
        ],
      ),
    );
  }
}
