import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class InsightCard extends StatelessWidget {
  final AIInsight insight;
  final ValueChanged<int> onRemovePoint;
  final void Function(int index, String newText) onEditPoint;

  const InsightCard({
    super.key,
    required this.insight,
    required this.onRemovePoint,
    required this.onEditPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MarginColors.surface,
        borderRadius: MarginRadii.cardRadius,
        border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.4), width: 1.2),
        boxShadow: MarginShadows.ambientGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detected idea banner
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MarginColors.butter.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.star_rounded, color: MarginColors.butter, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.detectedTitle,
                      style: MarginTypography.headingSmall,
                    ),
                    Text(
                      "A new project idea detected",
                      style: MarginTypography.caption.copyWith(color: MarginColors.lavender),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            insight.ideaDescription,
            style: MarginTypography.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Project details preview row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: MarginColors.elevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: MarginColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetaCol("Type", insight.category),
                Container(height: 24, width: 1, color: MarginColors.border),
                _buildMetaCol("Priority", insight.priority),
                Container(height: 24, width: 1, color: MarginColors.border),
                _buildMetaCol("Timeline", insight.timeline),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text("Key points extracted", style: MarginTypography.headingSmall.copyWith(fontSize: 15)),
              const Spacer(),
              Text(
                "Tap to edit or remove",
                style: MarginTypography.caption.copyWith(color: MarginColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // List of editable key points
          ...insight.keyPoints.asMap().entries.map((entry) {
            final idx = entry.key;
            final point = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: MarginColors.elevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MarginColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Icon(Icons.circle, size: 5, color: MarginColors.lavender),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: MarginTypography.bodyMedium.copyWith(color: MarginColors.textPrimary),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showEditDialog(context, idx, point),
                      child: const Icon(Icons.edit_outlined, size: 16, color: MarginColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onRemovePoint(idx),
                      child: const Icon(Icons.close_rounded, size: 16, color: MarginColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String initialText) {
    final textController = TextEditingController(text: initialText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MarginColors.elevated,
        title: Text("Edit Key Point", style: MarginTypography.headingSmall),
        content: TextField(
          controller: textController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Refine this point"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: MarginColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              onEditPoint(index, textController.text);
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCol(String label, String value) {
    return Column(
      children: [
        Text(label, style: MarginTypography.caption.copyWith(color: MarginColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w700, color: MarginColors.textPrimary)),
      ],
    );
  }
}
