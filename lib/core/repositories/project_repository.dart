import '../models/models.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects({bool includeArchived = false});

  Future<Project?> getProjectById(String id);

  Future<void> saveProject(Project project);

  Future<void> deleteProject(String id);

  Future<void> archiveProject(String id, {bool archived = true});

  Stream<List<Project>> watchProjects();
}
