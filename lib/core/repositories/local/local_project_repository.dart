import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  final StorageService _storageService;

  LocalProjectRepository([StorageService? storageService])
      : _storageService = storageService ?? StorageService.instance;

  Box get _box => _storageService.projectsBox;

  @override
  Future<List<Project>> getProjects({bool includeArchived = false}) async {
    final rawList = _box.values;
    final projects = <Project>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        final project = Project.fromMap(map);
        if (!includeArchived && project.isArchived) continue;
        projects.add(project);
      } catch (_) {}
    }

    return projects;
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      final map = (raw as Map).cast<String, dynamic>();
      return Project.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProject(Project project) async {
    await _box.put(project.id, project.toMap());
  }

  @override
  Future<void> deleteProject(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> archiveProject(String id, {bool archived = true}) async {
    final project = await getProjectById(id);
    if (project != null) {
      final updated = project.copyWith(isArchived: archived);
      await saveProject(updated);
    }
  }

  @override
  Stream<List<Project>> watchProjects() {
    return _box.watch().asyncMap((_) => getProjects());
  }
}
