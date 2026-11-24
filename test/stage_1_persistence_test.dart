import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:margin/core/models/models.dart';
import 'package:margin/core/services/storage_service.dart';
import 'package:margin/core/repositories/local/local_journal_repository.dart';
import 'package:margin/core/repositories/local/local_project_repository.dart';
import 'package:margin/core/repositories/local/local_task_repository.dart';
import 'package:margin/core/repositories/local/local_sync_queue_repository.dart';
import 'package:margin/core/services/state_service.dart';

void main() {
  group('Domain Model Serialization Tests', () {
    test('JournalEntry serialization round-trip', () {
      final entry = JournalEntry(
        id: 'test_j_1',
        title: 'Exploring Hybrid AI',
        content: 'Local models on device with cloud fallback.',
        originalTranscription: 'Local models on device with cloud fallback.',
        createdAt: DateTime(2026, 11, 24, 10, 0),
        updatedAt: DateTime(2026, 11, 24, 11, 0),
        tags: ['AI', 'Architecture'],
        linkedProjectId: 'proj_1',
        linkedProjectName: 'MARGIN',
        isDraft: false,
        isVoice: true,
        audioDurationSeconds: 45,
        isAnalyzed: true,
        insight: AIInsight(
          detectedTitle: 'Hybrid Architecture',
          ideaDescription: 'On-device AI pipeline',
          category: 'Engineering',
          priority: 'High',
          timeline: '2 weeks',
          keyPoints: ['Privacy first', 'Fast response'],
          actionPlan: [
            ActionPlanItem(id: 'ap_1', title: 'Setup Hive box', isSelected: true),
          ],
          isCloudAnalyzed: false,
        ),
      );

      final jsonString = entry.toJson();
      final decoded = JournalEntry.fromJson(jsonString);

      expect(decoded.id, entry.id);
      expect(decoded.title, entry.title);
      expect(decoded.content, entry.content);
      expect(decoded.originalTranscription, entry.originalTranscription);
      expect(decoded.createdAt, entry.createdAt);
      expect(decoded.updatedAt, entry.updatedAt);
      expect(decoded.tags, ['AI', 'Architecture']);
      expect(decoded.linkedProjectId, 'proj_1');
      expect(decoded.isVoice, isTrue);
      expect(decoded.audioDurationSeconds, 45);
      expect(decoded.isAnalyzed, isTrue);
      expect(decoded.insight, isNotNull);
      expect(decoded.insight!.detectedTitle, 'Hybrid Architecture');
      expect(decoded.insight!.actionPlan.length, 1);
      expect(decoded.insight!.actionPlan.first.title, 'Setup Hive box');
    });

    test('TaskItem serialization round-trip', () {
      final task = TaskItem(
        id: 'task_100',
        title: 'Verify AES Encryption',
        description: 'Verify 256-bit Hive cipher',
        isCompleted: true,
        priority: TaskPriority.high,
        dueDate: DateTime(2026, 11, 25),
        projectId: 'proj_1',
        projectName: 'MARGIN',
        sourceJournalId: 'test_j_1',
        assignee: 'Abdul',
        subtasks: ['Key generation', 'Box cipher test'],
      );

      final jsonStr = task.toJson();
      final decoded = TaskItem.fromJson(jsonStr);

      expect(decoded.id, task.id);
      expect(decoded.title, task.title);
      expect(decoded.isCompleted, isTrue);
      expect(decoded.priority, TaskPriority.high);
      expect(decoded.subtasks.length, 2);
    });

    test('Project serialization round-trip', () {
      final project = Project(
        id: 'proj_test',
        name: 'MARGIN V2',
        category: 'Design Engineering',
        description: 'Midnight Bloom UI/UX System',
        progress: 0.90,
        priority: TaskPriority.high,
        nextMilestone: 'Persistent Repositories',
        dueDate: DateTime(2026, 12, 1),
        colorValue: 0xFF7655E8,
        iconName: 'sparkles',
        memberCount: 3,
        decisions: ['AES-256 local encrypted storage'],
        isArchived: false,
      );

      final jsonStr = project.toJson();
      final decoded = Project.fromJson(jsonStr);

      expect(decoded.id, project.id);
      expect(decoded.name, project.name);
      expect(decoded.progress, 0.90);
      expect(decoded.priority, TaskPriority.high);
      expect(decoded.decisions, ['AES-256 local encrypted storage']);
      expect(decoded.isArchived, isFalse);
    });

    test('SyncOperation serialization round-trip', () {
      final op = SyncOperation(
        id: 'sync_1',
        entityType: 'journal',
        entityId: 'j_1',
        action: 'create',
        payload: {'title': 'Sample Note'},
        timestamp: DateTime(2026, 11, 24),
        retryCount: 1,
        status: 'pending',
      );

      final jsonStr = op.toJson();
      final decoded = SyncOperation.fromJson(jsonStr);

      expect(decoded.id, 'sync_1');
      expect(decoded.entityType, 'journal');
      expect(decoded.payload['title'], 'Sample Note');
      expect(decoded.retryCount, 1);
      expect(decoded.status, 'pending');
    });
  });

  group('Encrypted Hive Repositories & Offline Queue Integration', () {
    late Directory tempDir;
    late StorageService storageService;
    late Uint8List testKey;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('margin_hive_test_');
      Hive.init(tempDir.path);

      // Create a deterministic 32-byte (256-bit) test encryption key
      testKey = Uint8List(32);
      for (int i = 0; i < 32; i++) {
        testKey[i] = (i * 7 + 13) % 256;
      }

      storageService = StorageService.instance;
      await storageService.initialize(
        inMemory: true,
        overrideKey: testKey,
      );
    });

    tearDown(() async {
      await storageService.close();
      await Hive.deleteFromDisk();
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test('LocalJournalRepository saves, retrieves, searches, and deletes entries', () async {
      final repo = LocalJournalRepository(storageService);

      final entry1 = JournalEntry(
        id: 'j_alpha',
        title: 'Morning Reflections on Design',
        content: 'Soft lavender gradients and clean typography.',
        createdAt: DateTime(2026, 11, 24, 8, 30),
        updatedAt: DateTime(2026, 11, 24, 8, 30),
        tags: ['Design', 'MidnightBloom'],
      );

      final entry2 = JournalEntry(
        id: 'j_beta',
        title: 'Backend Persistence Strategy',
        content: 'Encrypted Hive box with secure storage keys.',
        createdAt: DateTime(2026, 11, 24, 9, 0),
        updatedAt: DateTime(2026, 11, 24, 9, 0),
        tags: ['Engineering', 'Security'],
      );

      await repo.saveEntry(entry1);
      await repo.saveEntry(entry2);

      final all = await repo.getEntries();
      expect(all.length, 2);
      // Newest first
      expect(all.first.id, 'j_beta');

      final found = await repo.getEntryById('j_alpha');
      expect(found, isNotNull);
      expect(found!.title, 'Morning Reflections on Design');

      // Search
      final searchResults = await repo.searchEntries('lavender');
      expect(searchResults.length, 1);
      expect(searchResults.first.id, 'j_alpha');

      // Delete
      await repo.deleteEntry('j_alpha');
      final remaining = await repo.getEntries();
      expect(remaining.length, 1);
      expect(remaining.first.id, 'j_beta');
    });

    test('LocalProjectRepository archives and persists projects', () async {
      final repo = LocalProjectRepository(storageService);

      final project = Project(
        id: 'p_1',
        name: 'Test Project',
        category: 'Product',
        description: 'Test Description',
        nextMilestone: 'Deploy',
        colorValue: 0xFF7655E8,
        iconName: 'sparkles',
      );

      await repo.saveProject(project);

      var projects = await repo.getProjects();
      expect(projects.length, 1);
      expect(projects.first.isArchived, isFalse);

      await repo.archiveProject('p_1', archived: true);

      // Without archived
      projects = await repo.getProjects(includeArchived: false);
      expect(projects.isEmpty, isTrue);

      // With archived
      projects = await repo.getProjects(includeArchived: true);
      expect(projects.length, 1);
      expect(projects.first.isArchived, isTrue);
    });

    test('LocalTaskRepository manages task completion toggle and filtering', () async {
      final repo = LocalTaskRepository(storageService);

      final task = TaskItem(
        id: 't_toggle',
        title: 'Check Task Status',
        isCompleted: false,
        priority: TaskPriority.high,
        projectId: 'p_1',
      );

      await repo.saveTask(task);

      var tasks = await repo.getTasks(projectId: 'p_1', isCompleted: false);
      expect(tasks.length, 1);

      await repo.toggleTask('t_toggle');

      final toggled = await repo.getTaskById('t_toggle');
      expect(toggled!.isCompleted, isTrue);

      tasks = await repo.getTasks(projectId: 'p_1', isCompleted: false);
      expect(tasks.isEmpty, isTrue);
    });

    test('LocalSyncQueueRepository manages retry count and FIFO pending queue', () async {
      final syncQueue = LocalSyncQueueRepository(storageService);

      final op1 = SyncOperation(
        id: 'op_1',
        entityType: 'task',
        entityId: 't_1',
        action: 'create',
        payload: {'title': 'Task 1'},
        timestamp: DateTime(2026, 11, 24, 10, 0),
      );

      final op2 = SyncOperation(
        id: 'op_2',
        entityType: 'task',
        entityId: 't_2',
        action: 'create',
        payload: {'title': 'Task 2'},
        timestamp: DateTime(2026, 11, 24, 10, 5),
      );

      await syncQueue.enqueueOperation(op1);
      await syncQueue.enqueueOperation(op2);

      var pending = await syncQueue.getPendingOperations();
      expect(pending.length, 2);
      expect(pending.first.id, 'op_1'); // FIFO order

      // Mark op1 completed (dequeued)
      await syncQueue.markCompleted('op_1');
      pending = await syncQueue.getPendingOperations();
      expect(pending.length, 1);
      expect(pending.first.id, 'op_2');

      // Test failure & retry count
      await syncQueue.markFailed('op_2');
      pending = await syncQueue.getPendingOperations();
      expect(pending.first.retryCount, 1);
      expect(pending.first.status, 'pending');

      // Fail 4 more times to reach max limit
      await syncQueue.markFailed('op_2');
      await syncQueue.markFailed('op_2');
      await syncQueue.markFailed('op_2');
      await syncQueue.markFailed('op_2');

      // Status should transition to 'failed' and no longer be pending
      pending = await syncQueue.getPendingOperations();
      expect(pending.isEmpty, isTrue);
    });

    test('StateService seeds initial data to repository on first launch and updates persist', () async {
      final stateService = StateService.instance;
      await stateService.initialize(storageService: storageService);

      expect(stateService.isStorageInitialized, isTrue);
      expect(stateService.projects.isNotEmpty, isTrue);
      expect(stateService.tasks.isNotEmpty, isTrue);
      expect(stateService.journalEntries.isNotEmpty, isTrue);

      // Add new journal entry via StateService
      final newEntry = JournalEntry(
        id: 'j_user_created',
        title: 'New User Thought',
        content: 'This should be saved to repository and sync queue.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await stateService.addJournalEntry(newEntry);

      // Verify it was persisted to storage
      final retrieved = await stateService.journalRepository.getEntryById('j_user_created');
      expect(retrieved, isNotNull);
      expect(retrieved!.title, 'New User Thought');

      // Verify sync queue enqueued operation
      final pendingSync = await stateService.syncQueueRepository.getPendingOperations();
      expect(pendingSync.any((op) => op.entityId == 'j_user_created'), isTrue);
    });
  });
}
