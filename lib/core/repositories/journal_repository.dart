import '../models/models.dart';

abstract class JournalRepository {
  Future<List<JournalEntry>> getEntries({
    bool? isDraft,
    bool? isAnalyzed,
    String? linkedProjectId,
  });

  Future<JournalEntry?> getEntryById(String id);

  Future<void> saveEntry(JournalEntry entry);

  Future<void> deleteEntry(String id);

  Future<List<JournalEntry>> searchEntries(String query);

  Stream<List<JournalEntry>> watchEntries();
}
