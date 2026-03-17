// Lab 11.3 – Navigation Test: TaskList → TaskDetail
// Run: flutter test test/lab11/widget/task_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lab/lab11/models/task.dart';
import '../../../lab/lab11/repository/task_repository.dart';
import '../../../lab/lab11/screens/task_list_screen.dart';

void main() {
  group('Navigation Tests: TaskList → TaskDetail', () {
    // ── Test 1: Tapping a task opens TaskDetailScreen ────────────────────
    testWidgets('tapping a task navigates to TaskDetailScreen', (tester) async {
      // Arrange – seed repository with one task
      final repo = TaskRepository();
      repo.addTask(Task(id: '1', title: 'Seeded Task'));

      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      // Act – tap the seeded task
      await tester.tap(find.text('Seeded Task'));
      await tester.pumpAndSettle(); // Wait for navigation animation

      // Assert – TaskDetailScreen AppBar title
      expect(find.text('Task Detail'), findsOneWidget);
    });

    // ── Test 2: TaskDetailScreen has title input field ───────────────────
    testWidgets('TaskDetailScreen shows detailTitleField', (tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: '2', title: 'Navigate to me'));

      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      // Act
      await tester.tap(find.text('Navigate to me'));
      await tester.pumpAndSettle();

      // Assert – detail title input field exists
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });

    // ── Test 3: Task title is pre-filled in detail screen ────────────────
    testWidgets('TaskDetailScreen pre-fills task title', (tester) async {
      final repo = TaskRepository();
      repo.addTask(Task(id: '3', title: 'Pre-filled title'));

      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      await tester.tap(find.text('Pre-filled title'));
      await tester.pumpAndSettle();

      final inputField = tester.widget<TextField>(
        find.byKey(const Key('detailTitleField')),
      );
      expect(inputField.controller?.text, equals('Pre-filled title'));
    });

    // ── Test 4: Back navigation returns to TaskListScreen ────────────────
    testWidgets('back navigation returns to TaskListScreen', (tester) async {
      final repo = TaskRepository();
      repo.addTask(Task(id: '4', title: 'Back test task'));

      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      await tester.tap(find.text('Back test task'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back at TaskListScreen
      expect(find.text('Back test task'), findsOneWidget);
      expect(find.text('Task Detail'), findsNothing);
    });
  });
}
