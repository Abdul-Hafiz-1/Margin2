import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import 'priority_indicator.dart';

class TaskTile extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onTap,
  });

  String _formatDueDate(DateTime? date) {
    if (date == null) return "";
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return "Today";
    if (target == today.add(const Duration(days: 1))) return "Tomorrow";
    if (target == today.subtract(const Duration(days: 1))) return "Yesterday";
    return "${date.day}/${date.month}";
  }

  @override
  Widget build(BuildContext context) {
    final dueDateText = _formatDueDate(task.dueDate);

    return InkWell(
      onTap: onTap,
      borderRadius: MarginRadii.buttonRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: MarginColors.surface,
          borderRadius: MarginRadii.buttonRadius,
          border: Border.all(color: MarginColors.border, width: 1.0),
        ),
        child: Row(
          children: [
            // Circular Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? MarginColors.lavender : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted ? MarginColors.lavender : MarginColors.textMuted,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: MarginColors.background)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            // Title and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: MarginTypography.bodyMediumBold.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? MarginColors.textMuted : MarginColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (dueDateText.isNotEmpty) ...[
                        Text(
                          dueDateText,
                          style: MarginTypography.caption.copyWith(
                            color: dueDateText == "Today"
                                ? MarginColors.peach
                                : MarginColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (task.projectName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: MarginColors.elevated,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: MarginColors.border),
                          ),
                          child: Text(
                            task.projectName!,
                            style: MarginTypography.caption.copyWith(
                              color: MarginColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            PriorityIndicator(priority: task.priority),
          ],
        ),
      ),
    );
  }
}
