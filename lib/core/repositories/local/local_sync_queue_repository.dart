import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../sync_queue_repository.dart';

class LocalSyncQueueRepository implements SyncQueueRepository {
  final StorageService _storageService;

  LocalSyncQueueRepository([StorageService? storageService])
      : _storageService = storageService ?? StorageService.instance;

  Box get _box => _storageService.syncQueueBox;

  @override
  Future<void> enqueueOperation(SyncOperation operation) async {
    await _box.put(operation.id, operation.toMap());
  }

  @override
  Future<List<SyncOperation>> getPendingOperations() async {
    final rawList = _box.values;
    final ops = <SyncOperation>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        final op = SyncOperation.fromMap(map);
        if (op.status == 'pending') {
          ops.add(op);
        }
      } catch (_) {}
    }

    ops.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return ops;
  }

  @override
  Future<void> markCompleted(String operationId) async {
    await _box.delete(operationId);
  }

  @override
  Future<void> markFailed(String operationId) async {
    final raw = _box.get(operationId);
    if (raw != null) {
      final map = (raw as Map).cast<String, dynamic>();
      final op = SyncOperation.fromMap(map);
      op.retryCount += 1;
      op.status = op.retryCount >= 5 ? 'failed' : 'pending';
      await _box.put(operationId, op.toMap());
    }
  }

  @override
  Future<int> getPendingCount() async {
    final ops = await getPendingOperations();
    return ops.length;
  }

  @override
  Future<void> clearQueue() async {
    await _box.clear();
  }

  @override
  Stream<int> watchPendingCount() {
    return _box.watch().asyncMap((_) => getPendingCount());
  }
}
