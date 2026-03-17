
import 'package:flutter/material.dart';
import 'exercises/exercise01.dart';
import 'exercises/exercise02.dart';
import 'exercises/exercise03.dart';
import 'exercises/exercise04.dart';
import 'exercises/exercise05.dart';

void main() {
  runApp(const Lab04App());
}

class Lab04App extends StatelessWidget {
  const Lab04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 04 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 04 - Flutter UI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.flutter_dash, size: 64, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(
                    'Flutter UI Fundamentals',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Select an exercise to view a demo.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Exercise buttons
          _buildExerciseButton(
            context,
            number: 1,
            title: 'Core Widgets',
            subtitle: 'Text, Image, Icon, Card, ListTile',
            icon: Icons.widgets,
            color: Colors.blue,
            screen: const Exercise01(),
          ),
          _buildExerciseButton(
            context,
            number: 2,
            title: 'Input Widgets',
            subtitle: 'Slider, Switch, Radio, DatePicker',
            icon: Icons.toggle_on,
            color: Colors.green,
            screen: const Exercise02(),
          ),
          _buildExerciseButton(
            context,
            number: 3,
            title: 'Layout Basics',
            subtitle: 'Column, Row, Padding, ListView',
            icon: Icons.view_column,
            color: Colors.orange,
            screen: const Exercise03(),
          ),
          _buildExerciseButton(
            context,
            number: 4,
            title: 'Scaffold & Theme',
            subtitle: 'AppBar, FAB, Dark Mode Toggle',
            icon: Icons.palette,
            color: Colors.purple,
            screen: const Exercise04(),
          ),
          _buildExerciseButton(
            context,
            number: 5,
            title: 'Debug & Fix Errors',
            subtitle: 'Common UI issues & solutions',
            icon: Icons.bug_report,
            color: Colors.red,
            screen: const Exercise05(),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(
      BuildContext context, {
        required int number,
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget screen,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text('$number', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(icon, color: color),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}