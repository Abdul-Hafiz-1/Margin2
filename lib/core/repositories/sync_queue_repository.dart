import '../models/models.dart';

abstract class SyncQueueRepository {
  Future<void> enqueueOperation(SyncOperation operation);

  Future<List<SyncOperation>> getPendingOperations();

  Future<void> markCompleted(String operationId);

  Future<void> markFailed(String operationId);

  Future<int> getPendingCount();

  Future<void> clearQueue();

  Stream<int> watchPendingCount();
}
