import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class ThoughtCaptureCard extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback onSubmitted;
  final VoidCallback onVoiceTap;
  final VoidCallback? onAttachTap;
  final VoidCallback? onQuickTaskTap;

  const ThoughtCaptureCard({
    super.key,
    this.controller,
    required this.onSubmitted,
    required this.onVoiceTap,
    this.onAttachTap,
    this.onQuickTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MarginColors.surface,
        borderRadius: MarginRadii.cardRadius,
        border: Border.all(color: MarginColors.border, width: 1.0),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: MarginColors.elevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MarginColors.border),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onVoiceTap,
                        child: const Icon(
                          Icons.mic_none_rounded,
                          color: MarginColors.lavender,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: MarginTypography.bodyMedium.copyWith(
                            color: MarginColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: MarginTypography.bodyMedium.copyWith(
                              color: MarginColors.textMuted,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => onSubmitted(),
                        ),
                      ),
                      GestureDetector(
                        onTap: onSubmitted,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MarginColors.lavender,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: MarginColors.lavender.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: MarginColors.background,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick action buttons
          Row(
            children: [
              _buildQuickPill(
                icon: Icons.mic_rounded,
                label: "Dictate",
                onTap: onVoiceTap,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.attach_file_rounded,
                label: "Attach",
                onTap: onAttachTap,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.check_circle_outline_rounded,
                label: "Quick Task",
                onTap: onQuickTaskTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPill({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: MarginColors.elevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MarginColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: MarginColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: MarginTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: MarginColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
