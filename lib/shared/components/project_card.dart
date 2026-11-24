import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isHorizontalCompact;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isHorizontalCompact = false,
  });

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case "sparkles":
        return Icons.auto_awesome_rounded;
      case "play":
        return Icons.play_arrow_rounded;
      case "shirt":
        return Icons.checkroom_rounded;
      case "leaf":
        return Icons.spa_rounded;
      default:
        return Icons.folder_open_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(project.colorValue);

    if (isHorizontalCompact) {
      return InkWell(
        onTap: onTap,
        borderRadius: MarginRadii.cardRadius,
        child: Container(
          width: 175,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MarginColors.surface,
            borderRadius: MarginRadii.cardRadius,
            border: Border.all(color: MarginColors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getIcon(project.iconName), color: color, size: 18),
                  ),
                  Text(
                    "${(project.progress * 100).toInt()}%",
                    style: MarginTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: MarginTypography.headingSmall.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    project.category,
                    style: MarginTypography.caption.copyWith(color: MarginColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progress,
                  backgroundColor: MarginColors.elevated,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Full List Project Card
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_getIcon(project.iconName), color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.name, style: MarginTypography.headingSmall),
                      Text(
                        project.category,
                        style: MarginTypography.caption.copyWith(color: MarginColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${(project.progress * 100).toInt()}%",
                  style: MarginTypography.bodyMediumBold.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: MarginTypography.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.progress,
                backgroundColor: MarginColors.elevated,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.flag_outlined, size: 14, color: MarginColors.textMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    project.nextMilestone,
                    style: MarginTypography.caption.copyWith(
                      color: MarginColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: MarginColors.elevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: MarginColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 13, color: MarginColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        "${project.memberCount}",
                        style: MarginTypography.caption.copyWith(
                          color: MarginColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
