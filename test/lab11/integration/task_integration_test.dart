// Lab 11.4 – Integration Test: Full Task Flow
// Run: flutter test test/lab11/integration/task_integration_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lab/lab11/repository/task_repository.dart';
import '../../../lab/lab11/screens/task_list_screen.dart';

void main() {
  group('Integration Test: Full Task Flow', () {
    // ── Full flow: Add → Open Detail → Edit → Save → Verify ─────────────
    testWidgets(
      'add task, edit title in detail, verify updated title in list',
      (tester) async {
        // Arrange
        final repo = TaskRepository();
        await tester.pumpWidget(
          MaterialApp(home: TaskListScreen(repository: repo)),
        );

        // Step 1: Add "Original title"
        await tester.enterText(
            find.byKey(const Key('taskInputField')), 'Original title');
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();
        expect(find.text('Original title'), findsOneWidget);

        // Step 2: Tap the task to open detail
        await tester.tap(find.text('Original title'));
        await tester.pumpAndSettle();
        expect(find.text('Task Detail'), findsOneWidget);

        // Step 3: Clear and type new title
        final detailField = find.byKey(const Key('detailTitleField'));
        await tester.tap(detailField);
        await tester.pump();
        await tester.enterText(detailField, 'Updated title');
        await tester.pump();

        // Step 4: Save
        await tester.tap(find.text('Save Changes'));
        await tester.pumpAndSettle();

        // Step 5: Verify updated title in list
        expect(find.text('Updated title'), findsOneWidget);
        expect(find.text('Original title'), findsNothing);
      },
    );

    // ── Delete task flow ──────────────────────────────────────────────────
    testWidgets('add task then delete it removes it from list', (tester) async {
      final repo = TaskRepository();
      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      // Add task
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Delete me');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();
      expect(find.text('Delete me'), findsOneWidget);

      // Delete
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Verify deleted
      expect(find.text('Delete me'), findsNothing);
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    // ── Multiple tasks flow ───────────────────────────────────────────────
    testWidgets('can add 3 tasks and all appear in list', (tester) async {
      final repo = TaskRepository();
      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repo)),
      );

      final titles = ['Task One', 'Task Two', 'Task Three'];
      for (final title in titles) {
        await tester.enterText(
            find.byKey(const Key('taskInputField')), title);
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();
      }

      for (final title in titles) {
        expect(find.text(title), findsOneWidget);
      }
      expect(repo.tasks.length, equals(3));
    });
  });
}
