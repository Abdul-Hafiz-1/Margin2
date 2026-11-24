import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String description;
  final List<String> itemsToCreate;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmSheet({
    super.key,
    required this.title,
    required this.description,
    required this.itemsToCreate,
    this.confirmLabel = "Confirm & Add",
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> itemsToCreate,
    String confirmLabel = "Confirm & Add",
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ConfirmSheet(
        title: title,
        description: description,
        itemsToCreate: itemsToCreate,
        confirmLabel: confirmLabel,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MarginColors.surface,
        borderRadius: MarginRadii.sheetRadius,
        border: const Border(top: BorderSide(color: MarginColors.borderLight, width: 1.0)),
        boxShadow: MarginShadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: MarginColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MarginColors.lavender.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield_outlined, color: MarginColors.lavender, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: MarginTypography.headingMedium)),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: MarginTypography.bodyMedium),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MarginColors.elevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MarginColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items to be added:",
                  style: MarginTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MarginColors.lavender,
                  ),
                ),
                const SizedBox(height: 8),
                ...itemsToCreate.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 16, color: MarginColors.mint),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item, style: MarginTypography.bodySmall),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Review / Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.lavender,
                    foregroundColor: MarginColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
