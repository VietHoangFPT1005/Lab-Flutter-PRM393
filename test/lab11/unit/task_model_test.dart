// Lab 11.1 – Unit Test: Task Model
// Run: flutter test test/lab11/unit/task_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lab/lab11/models/task.dart';

void main() {
  group('Task Model Tests', () {
    // ── Test 1: Default completed value ──────────────────────────────────
    test('Task default completed value is false', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy groceries');

      // Act & Assert
      expect(task.completed, isFalse);
    });

    // ── Test 2: toggle() switches false → true ───────────────────────────
    test('toggle() switches completed from false to true', () {
      // Arrange
      final task = Task(id: '2', title: 'Read a book', completed: false);

      // Act
      task.toggle();

      // Assert
      expect(task.completed, isTrue);
    });

    // ── Test 3: toggle() switches true → false ───────────────────────────
    test('toggle() switches completed from true to false', () {
      // Arrange
      final task = Task(id: '3', title: 'Exercise', completed: true);

      // Act
      task.toggle();

      // Assert
      expect(task.completed, isFalse);
    });

    // ── Test 4: double toggle returns to original state ──────────────────
    test('double toggle returns to original state', () {
      // Arrange
      final task = Task(id: '4', title: 'Study Flutter');
      final originalState = task.completed;

      // Act
      task.toggle();
      task.toggle();

      // Assert
      expect(task.completed, equals(originalState));
    });

    // ── Test 5: Task stores title correctly ──────────────────────────────
    test('Task stores id and title correctly', () {
      const id = 'abc-123';
      const title = 'Write unit tests';

      final task = Task(id: id, title: title);

      expect(task.id, equals(id));
      expect(task.title, equals(title));
    });

    // ── Test 6: copyWith preserves unchanged fields ──────────────────────
    test('copyWith creates new task with updated fields', () {
      final original = Task(id: '5', title: 'Old title', completed: false);
      final copy = original.copyWith(title: 'New title', completed: true);

      expect(copy.id, equals('5'));
      expect(copy.title, equals('New title'));
      expect(copy.completed, isTrue);
    });
  });
}
