import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class ActionPlanCard extends StatelessWidget {
  final List<ActionPlanItem> items;
  final ValueChanged<int> onToggleItem;
  final VoidCallback onCreateProject;
  final VoidCallback onSaveInsights;
  final VoidCallback onRefinePlan;
  final VoidCallback onAskMargo;

  const ActionPlanCard({
    super.key,
    required this.items,
    required this.onToggleItem,
    required this.onCreateProject,
    required this.onSaveInsights,
    required this.onRefinePlan,
    required this.onAskMargo,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCount = items.where((i) => i.isSelected).length;

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text(
                "Your Action Plan",
                style: MarginTypography.headingSmall,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: MarginColors.lavender.withValues(alpha: 0.15),
                  borderRadius: MarginRadii.pillRadius,
                  border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.3)),
                ),
                child: Text(
                  "$selectedCount of ${items.length} selected",
                  style: MarginTypography.caption.copyWith(
                    color: MarginColors.lavender,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Select which tasks to schedule. MARGIN never creates tasks silently without your explicit approval.",
            style: MarginTypography.bodySmall,
          ),
          const SizedBox(height: 14),
          // List of selectable tasks
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            return InkWell(
              onTap: () => onToggleItem(idx),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: item.isSelected ? MarginColors.lavender : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.isSelected ? MarginColors.lavender : MarginColors.textMuted,
                          width: 2,
                        ),
                      ),
                      child: item.isSelected
                          ? const Icon(Icons.check, size: 14, color: MarginColors.background)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: MarginTypography.bodyMedium.copyWith(
                          color: item.isSelected ? MarginColors.textPrimary : MarginColors.textMuted,
                          decoration: item.isSelected ? null : TextDecoration.lineThrough,
                          fontWeight: item.isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Actions
          Text(
            "What would you like to do?",
            style: MarginTypography.headingSmall.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedCount > 0 ? onCreateProject : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.lavender,
                    foregroundColor: MarginColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text("Create Project"),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: onSaveInsights,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                icon: const Icon(Icons.bookmark_border_rounded, size: 18),
                label: const Text("Save"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRefinePlan,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text("Refine Plan"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAskMargo,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text("Ask Margo"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
