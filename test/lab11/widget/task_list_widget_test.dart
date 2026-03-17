// Lab 11.2 – Widget Test: TaskListScreen UI
// Run: flutter test test/lab11/widget/task_list_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lab/lab11/repository/task_repository.dart';
import '../../../lab/lab11/screens/task_list_screen.dart';

Widget _buildApp(TaskRepository repo) {
  return MaterialApp(home: TaskListScreen(repository: repo));
}

void main() {
  group('TaskListScreen Widget Tests', () {
    // ── Test 1: Empty State ───────────────────────────────────────────────
    testWidgets('shows empty state message when no tasks', (tester) async {
      // Arrange
      final repo = TaskRepository();

      // Act
      await tester.pumpWidget(_buildApp(repo));

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    // ── Test 2: Add Task ──────────────────────────────────────────────────
    testWidgets('adds a task and shows it in the list', (tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(_buildApp(repo));

      // Act – enter text and tap Add
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Buy milk');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    // ── Test 3: Multiple Tasks ────────────────────────────────────────────
    testWidgets('shows multiple tasks after adding them', (tester) async {
      final repo = TaskRepository();
      await tester.pumpWidget(_buildApp(repo));

      // Add first task
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task Alpha');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Add second task
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task Beta');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert both are visible
      expect(find.text('Task Alpha'), findsOneWidget);
      expect(find.text('Task Beta'), findsOneWidget);
    });

    // ── Test 4: Empty input is ignored ────────────────────────────────────
    testWidgets('does not add empty task', (tester) async {
      final repo = TaskRepository();
      await tester.pumpWidget(_buildApp(repo));

      // Tap Add without entering text
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Should still show empty state
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
      expect(repo.tasks, isEmpty);
    });

    // ── Test 5: Input field clears after add ──────────────────────────────
    testWidgets('input field clears after adding task', (tester) async {
      final repo = TaskRepository();
      await tester.pumpWidget(_buildApp(repo));

      await tester.enterText(find.byKey(const Key('taskInputField')), 'Clean room');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      final inputField = tester.widget<TextField>(
        find.byKey(const Key('taskInputField')),
      );
      expect(inputField.controller?.text, equals(''));
    });
  });
}
