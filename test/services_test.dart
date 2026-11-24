import 'package:flutter_test/flutter_test.dart';
import 'package:margin/core/models/models.dart';
import 'package:margin/core/services/inference_service.dart';
import 'package:margin/core/services/state_service.dart';

void main() {
  group('InferenceService & Hybrid Engine', () {
    test('InferenceService toggles preference correctly', () {
      final inference = InferenceService.instance;
      expect(inference.preferLocal, isTrue);
      inference.setPreferLocal(false);
      expect(inference.preferLocal, isFalse);
      inference.setPreferLocal(true);
    });

    test('generateInsightForText detects clothing brand', () {
      final inference = InferenceService.instance;
      final insight = inference.generateInsightForText(
        "I've been thinking about starting a clothing brand with oversized t-shirts",
      );
      expect(insight.detectedTitle, contains("Clothing"));
      expect(insight.keyPoints.length, greaterThanOrEqualTo(3));
      expect(insight.actionPlan.length, greaterThanOrEqualTo(3));
    });
  });

  group('StateService Repository', () {
    test('Initializes with seeded projects, tasks, and journal entries', () {
      final state = StateService.instance;
      expect(state.projects, isNotEmpty);
      expect(state.tasks, isNotEmpty);
      expect(state.journalEntries, isNotEmpty);
      expect(state.teamMembers.length, 4);
    });

    test('Can add a new journal entry and toggle tasks', () {
      final state = StateService.instance;
      final initialCount = state.journalEntries.length;
      final newEntry = JournalEntry(
        id: "test_entry_1",
        title: "Test Note",
        content: "Testing journal state persistence",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      state.addJournalEntry(newEntry);
      expect(state.journalEntries.length, initialCount + 1);

      final task = state.tasks.first;
      final prevStatus = task.isCompleted;
      state.toggleTaskCompletion(task.id);
      expect(task.isCompleted, !prevStatus);
    });
  });
}
