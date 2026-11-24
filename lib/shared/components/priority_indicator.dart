import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  const PriorityIndicator({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (priority) {
      case TaskPriority.high:
        bg = MarginColors.peach.withValues(alpha: 0.18);
        fg = MarginColors.peach;
        label = "High";
        break;
      case TaskPriority.medium:
        bg = MarginColors.butter.withValues(alpha: 0.18);
        fg = MarginColors.butter;
        label = "Medium";
        break;
      case TaskPriority.low:
        bg = MarginColors.mint.withValues(alpha: 0.18);
        fg = MarginColors.mint;
        label = "Low";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: MarginRadii.pillRadius,
        border: Border.all(color: fg.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: MarginTypography.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
