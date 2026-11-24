import 'package:flutter/material.dart';
import '../../core/services/inference_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class AIProcessingIndicator extends StatelessWidget {
  final VoidCallback? onTap;

  const AIProcessingIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: InferenceService.instance,
      builder: (context, _) {
        final service = InferenceService.instance;
        final isLocal = service.preferLocal;

        return InkWell(
          onTap: onTap,
          borderRadius: MarginRadii.pillRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isLocal
                  ? MarginColors.mint.withValues(alpha: 0.12)
                  : MarginColors.sky.withValues(alpha: 0.12),
              borderRadius: MarginRadii.pillRadius,
              border: Border.all(
                color: isLocal
                    ? MarginColors.mint.withValues(alpha: 0.35)
                    : MarginColors.sky.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLocal ? Icons.bolt_rounded : Icons.cloud_done_rounded,
                  size: 13,
                  color: isLocal ? MarginColors.mint : MarginColors.sky,
                ),
                const SizedBox(width: 5),
                Text(
                  isLocal ? "Hybrid (On-Device)" : "Cloud Reasoning",
                  style: MarginTypography.caption.copyWith(
                    color: isLocal ? MarginColors.mint : MarginColors.sky,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
