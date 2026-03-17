// Lab 11.1 – Unit Test: TaskRepository
// Run: flutter test test/lab11/unit/task_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lab/lab11/models/task.dart';
import '../../../lab/lab11/repository/task_repository.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    // Fresh repository before each test
    repository = TaskRepository();
  });

  group('TaskRepository Tests', () {
    // ── addTask() ────────────────────────────────────────────────────────
    group('addTask()', () {
      test('adds a task to the repository', () {
        // Arrange
        final task = Task(id: '1', title: 'Task A');

        // Act
        repository.addTask(task);

        // Assert
        expect(repository.tasks.length, equals(1));
        expect(repository.tasks.first.id, equals('1'));
        expect(repository.tasks.first.title, equals('Task A'));
      });

      test('adds multiple tasks', () {
        repository.addTask(Task(id: '1', title: 'Task 1'));
        repository.addTask(Task(id: '2', title: 'Task 2'));
        repository.addTask(Task(id: '3', title: 'Task 3'));

        expect(repository.tasks.length, equals(3));
      });
    });

    // ── deleteTask() ─────────────────────────────────────────────────────
    group('deleteTask()', () {
      test('removes task by id', () {
        // Arrange
        repository.addTask(Task(id: '1', title: 'To delete'));
        repository.addTask(Task(id: '2', title: 'To keep'));

        // Act
        repository.deleteTask('1');

        // Assert
        expect(repository.tasks.length, equals(1));
        expect(repository.tasks.first.id, equals('2'));
      });

      test('does nothing if id not found', () {
        repository.addTask(Task(id: '1', title: 'Task'));
        repository.deleteTask('non-existent');
        expect(repository.tasks.length, equals(1));
      });

      test('removes correct task from middle of list', () {
        repository.addTask(Task(id: 'a', title: 'A'));
        repository.addTask(Task(id: 'b', title: 'B'));
        repository.addTask(Task(id: 'c', title: 'C'));

        repository.deleteTask('b');

        expect(repository.tasks.length, equals(2));
        expect(repository.tasks.map((t) => t.id).toList(), ['a', 'c']);
      });
    });

    // ── updateTask() ─────────────────────────────────────────────────────
    group('updateTask()', () {
      test('updates task title', () {
        // Arrange
        final task = Task(id: '1', title: 'Old title');
        repository.addTask(task);

        // Act
        repository.updateTask(Task(id: '1', title: 'New title'));

        // Assert
        expect(repository.tasks.first.title, equals('New title'));
      });

      test('updates completed state', () {
        final task = Task(id: '1', title: 'Test', completed: false);
        repository.addTask(task);

        repository.updateTask(Task(id: '1', title: 'Test', completed: true));

        expect(repository.tasks.first.completed, isTrue);
      });

      test('does nothing if task id not found', () {
        repository.addTask(Task(id: '1', title: 'Original'));
        repository.updateTask(Task(id: '999', title: 'Ghost'));

        expect(repository.tasks.length, equals(1));
        expect(repository.tasks.first.title, equals('Original'));
      });
    });

    // ── tasks getter ─────────────────────────────────────────────────────
    group('tasks getter', () {
      test('returns empty list when no tasks added', () {
        expect(repository.tasks, isEmpty);
      });

      test('returns unmodifiable list', () {
        // List.unmodifiable throws UnsupportedError on mutation attempts
        expect(
          () => repository.tasks.add(Task(id: 'x', title: 'x')),
          throwsUnsupportedError,
        );
      });
    });
  });
}
