import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final StorageService _storageService;

  LocalTaskRepository([StorageService? storageService])
      : _storageService = storageService ?? StorageService.instance;

  Box get _box => _storageService.tasksBox;

  @override
  Future<List<TaskItem>> getTasks({
    String? projectId,
    bool? isCompleted,
  }) async {
    final rawList = _box.values;
    final tasks = <TaskItem>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        final task = TaskItem.fromMap(map);

        if (projectId != null && task.projectId != projectId) continue;
        if (isCompleted != null && task.isCompleted != isCompleted) continue;

        tasks.add(task);
      } catch (_) {}
    }

    return tasks;
  }

  @override
  Future<TaskItem?> getTaskById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      final map = (raw as Map).cast<String, dynamic>();
      return TaskItem.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveTask(TaskItem task) async {
    await _box.put(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> toggleTask(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updated = task.copyWith(isCompleted: !task.isCompleted);
      await saveTask(updated);
    }
  }

  @override
  Stream<List<TaskItem>> watchTasks() {
    return _box.watch().asyncMap((_) => getTasks());
  }
}
