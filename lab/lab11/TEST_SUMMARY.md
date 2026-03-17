# Lab 11 – Test Summary Report
**Project:** flutter2026 – Taskly App
**Date:** 2026-03-17
**Flutter SDK:** 3.10.7
**Command:** `flutter test test/lab11/`
**Result:** ✅ **28/28 tests PASSED**

---

## Test Suite Overview

| File | Type | Tests | Result |
|------|------|-------|--------|
| `test/lab11/unit/task_model_test.dart` | Unit | 6 | ✅ All passed |
| `test/lab11/unit/task_repository_test.dart` | Unit | 9 | ✅ All passed |
| `test/lab11/widget/task_list_widget_test.dart` | Widget | 5 | ✅ All passed |
| `test/lab11/widget/task_navigation_test.dart` | Widget/Navigation | 4 | ✅ All passed |
| `test/lab11/integration/task_integration_test.dart` | Integration | 3 | ✅ All passed |
| **Total** | | **28** | **✅ 28 passed, 0 failed** |

---

## Unit Tests – Task Model (`task_model_test.dart`)

| # | Test Name | Pattern | Result |
|---|-----------|---------|--------|
| 1 | `completed` defaults to false | AAA | ✅ |
| 2 | `toggle()` switches false → true | AAA | ✅ |
| 3 | `toggle()` switches true → false | AAA | ✅ |
| 4 | Double toggle returns to original state | AAA | ✅ |
| 5 | Task stores id and title correctly | AAA | ✅ |
| 6 | `copyWith()` preserves unchanged fields | AAA | ✅ |

---

## Unit Tests – Task Repository (`task_repository_test.dart`)

| # | Test Name | Result |
|---|-----------|--------|
| 1 | `addTask()` adds one task | ✅ |
| 2 | `addTask()` adds multiple tasks | ✅ |
| 3 | `deleteTask()` removes task by id | ✅ |
| 4 | `deleteTask()` handles not-found id | ✅ |
| 5 | `deleteTask()` removes from middle | ✅ |
| 6 | `updateTask()` updates title | ✅ |
| 7 | `updateTask()` updates completed state | ✅ |
| 8 | `tasks` getter returns empty list initially | ✅ |
| 9 | `tasks` getter returns unmodifiable list | ✅ |

---

## Widget Tests – TaskListScreen (`task_list_widget_test.dart`)

| # | Test Name | Result |
|---|-----------|--------|
| 1 | Shows "No tasks yet. Add one!" when empty | ✅ |
| 2 | Adds a task and shows it in the list | ✅ |
| 3 | Shows multiple tasks after adding them | ✅ |
| 4 | Does not add empty task | ✅ |
| 5 | Input field clears after adding task | ✅ |

---

## Navigation Tests (`task_navigation_test.dart`)

| # | Test Name | Result |
|---|-----------|--------|
| 1 | Tapping a task navigates to TaskDetailScreen | ✅ |
| 2 | TaskDetailScreen shows `detailTitleField` | ✅ |
| 3 | TaskDetailScreen pre-fills task title | ✅ |
| 4 | Back navigation returns to TaskListScreen | ✅ |

---

## Integration Tests (`task_integration_test.dart`)

| # | Test Name | Result |
|---|-----------|--------|
| 1 | Add → Open Detail → Edit title → Save → Verify updated in list | ✅ |
| 2 | Add task → Delete → Verify removed from list | ✅ |
| 3 | Add 3 tasks → All appear in list | ✅ |

---

## Test Keys Used

| Key | Location | Purpose |
|-----|----------|---------|
| `Key('taskInputField')` | TaskListScreen | Input field for new task |
| `Key('addTaskButton')` | TaskListScreen | Add button |
| `Key('emptyState')` | TaskListScreen | Empty state text |
| `Key('detailTitleField')` | TaskDetailScreen | Title editor in detail |

---

## Debugging Notes (DevTools)

**Widget Inspector Findings:**
- TaskListScreen renders a `Column` → `Padding` → `Row` (input) + `Expanded` → `ListView.builder`
- Each task is a `ListTile` with `ValueKey(task.id)` for efficient diffing
- Empty state uses `const Center` to avoid unnecessary rebuilds

**Performance Observations:**
- No janky frames detected during normal task add/delete operations
- `ListView.builder` only renders visible items (lazy loading)
- `const` constructors on static decoration widgets prevent unnecessary rebuilds

---

## Conclusion

All **28 tests passed** successfully covering:
- ✅ Unit logic (model + repository)
- ✅ Widget rendering and user interactions
- ✅ Screen navigation flow
- ✅ Full integration (Add → Edit → Delete cycle)

The Taskly app implementation is stable and all test cases pass without any errors.
