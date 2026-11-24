import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onAnalyzeTap;

  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onAnalyzeTap,
  });

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: MarginRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: MarginColors.surface,
          borderRadius: MarginRadii.cardRadius,
          border: Border.all(color: MarginColors.border, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (entry.isVoice) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MarginColors.elevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mic_rounded, size: 12, color: MarginColors.lavender),
                        const SizedBox(width: 4),
                        Text(
                          "${entry.audioDurationSeconds}s",
                          style: MarginTypography.caption.copyWith(
                            color: MarginColors.lavender,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (entry.linkedProjectName != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MarginColors.elevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MarginColors.borderLight),
                    ),
                    child: Text(
                      entry.linkedProjectName!,
                      style: MarginTypography.caption.copyWith(
                        color: MarginColors.sky,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Spacer(),
                Text(
                  _formatDate(entry.createdAt),
                  style: MarginTypography.metadata,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              entry.title,
              style: MarginTypography.headingSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              entry.content,
              style: MarginTypography.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // Tags
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: entry.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: MarginColors.elevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: MarginColors.border),
                        ),
                        child: Text(
                          "#$tag",
                          style: MarginTypography.caption.copyWith(
                            color: MarginColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Analyze or Analyzed badge
                if (entry.isAnalyzed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: MarginColors.mint.withValues(alpha: 0.15),
                      borderRadius: MarginRadii.pillRadius,
                      border: Border.all(color: MarginColors.mint.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 14, color: MarginColors.mint),
                        const SizedBox(width: 4),
                        Text(
                          "Analyzed",
                          style: MarginTypography.caption.copyWith(
                            color: MarginColors.mint,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: onAnalyzeTap,
                    borderRadius: MarginRadii.pillRadius,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: MarginColors.lavender,
                        borderRadius: MarginRadii.pillRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 13, color: MarginColors.background),
                          const SizedBox(width: 4),
                          Text(
                            "Analyse",
                            style: MarginTypography.caption.copyWith(
                              color: MarginColors.background,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
