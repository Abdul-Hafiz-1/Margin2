import '../models/models.dart';

abstract class TaskRepository {
  Future<List<TaskItem>> getTasks({
    String? projectId,
    bool? isCompleted,
  });

  Future<TaskItem?> getTaskById(String id);

  Future<void> saveTask(TaskItem task);

  Future<void> deleteTask(String id);

  Future<void> toggleTask(String id);

  Stream<List<TaskItem>> watchTasks();
}
