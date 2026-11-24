import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class SavedEntryScreen extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onAnalyze;
  final VoidCallback onDeleted;

  const SavedEntryScreen({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onAnalyze,
    required this.onDeleted,
  });

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text("Journal Entry", style: MarginTypography.headingMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: MarginColors.textPrimary),
            tooltip: "Edit",
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: MarginColors.error),
            tooltip: "Delete",
            onPressed: () {
              _confirmDelete(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Save Status & Source of Truth Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: MarginColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: MarginColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_outlined, size: 16, color: MarginColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Source of Truth — Original thought preserved",
                        style: MarginTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MarginColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      _formatDateTime(entry.createdAt),
                      style: MarginTypography.caption.copyWith(color: MarginColors.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                entry.title,
                style: MarginTypography.displayMedium.copyWith(fontSize: 26),
              ),

              const SizedBox(height: 12),

              // Badges: Project, Audio, Tags
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (entry.linkedProjectName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: MarginColors.skyLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_outlined, size: 14, color: Color(0xFF1B62C4)),
                          const SizedBox(width: 4),
                          Text(
                            entry.linkedProjectName!,
                            style: MarginTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B62C4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (entry.isVoice)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: MarginColors.lavenderSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.mic_rounded, size: 14, color: MarginColors.purple),
                          const SizedBox(width: 4),
                          Text(
                            "Voice Memo (${entry.audioDurationSeconds}s)",
                            style: MarginTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: MarginColors.purpleDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ...entry.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: MarginColors.surfaceWarm,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: MarginColors.borderLight),
                        ),
                        child: Text(
                          "#$tag",
                          style: MarginTypography.caption.copyWith(color: MarginColors.textSecondary),
                        ),
                      )),
                ],
              ),

              const SizedBox(height: 24),

              // Main Thought Content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: MarginColors.surfaceWhite,
                  borderRadius: MarginRadii.cardRadius,
                  border: Border.all(color: MarginColors.borderLight, width: 1.2),
                  boxShadow: MarginShadows.card,
                ),
                child: Text(
                  entry.content,
                  style: MarginTypography.bodyLarge.copyWith(height: 1.6),
                ),
              ),

              const SizedBox(height: 28),

              // Bottom Action Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF6F3FF), Color(0xFFFFF9F5)],
                  ),
                  borderRadius: MarginRadii.cardRadius,
                  border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Let Margo find clarity", style: MarginTypography.headingSmall.copyWith(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(
                            entry.isAnalyzed
                                ? "Re-analyse to discover additional tasks or blueprints"
                                : "Turn this note into structured milestones and tasks",
                            style: MarginTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: onAnalyze,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MarginColors.purple,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: Text(entry.isAnalyzed ? "Re-analyse" : "Analyse"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Entry?", style: MarginTypography.headingSmall),
        content: const Text("This entry will be permanently removed. This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              StateService.instance.deleteJournalEntry(entry.id);
              Navigator.pop(ctx);
              onDeleted();
            },
            style: ElevatedButton.styleFrom(backgroundColor: MarginColors.error),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
