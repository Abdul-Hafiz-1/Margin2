import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../journal_repository.dart';

class LocalJournalRepository implements JournalRepository {
  final StorageService _storageService;

  LocalJournalRepository([StorageService? storageService])
      : _storageService = storageService ?? StorageService.instance;

  Box get _box => _storageService.journalBox;

  @override
  Future<List<JournalEntry>> getEntries({
    bool? isDraft,
    bool? isAnalyzed,
    String? linkedProjectId,
  }) async {
    final rawList = _box.values;
    final entries = <JournalEntry>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        final entry = JournalEntry.fromMap(map);

        if (isDraft != null && entry.isDraft != isDraft) continue;
        if (isAnalyzed != null && entry.isAnalyzed != isAnalyzed) continue;
        if (linkedProjectId != null && entry.linkedProjectId != linkedProjectId) {
          continue;
        }

        entries.add(entry);
      } catch (_) {}
    }

    // Sort newest first
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  Future<JournalEntry?> getEntryById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      final map = (raw as Map).cast<String, dynamic>();
      return JournalEntry.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    await _box.put(entry.id, entry.toMap());
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<JournalEntry>> searchEntries(String query) async {
    if (query.trim().isEmpty) return getEntries();
    final lower = query.toLowerCase();
    final all = await getEntries();
    return all.where((entry) {
      final titleMatch = entry.title.toLowerCase().contains(lower);
      final contentMatch = entry.content.toLowerCase().contains(lower);
      final tagMatch = entry.tags.any((t) => t.toLowerCase().contains(lower));
      final projectMatch =
          entry.linkedProjectName?.toLowerCase().contains(lower) ?? false;
      return titleMatch || contentMatch || tagMatch || projectMatch;
    }).toList();
  }

  @override
  Stream<List<JournalEntry>> watchEntries() {
    return _box.watch().asyncMap((_) => getEntries());
  }
}
