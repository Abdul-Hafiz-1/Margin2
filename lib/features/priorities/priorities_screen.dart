import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class PrioritiesScreen extends StatelessWidget {
  final ValueChanged<Project> onSelectProject;

  const PrioritiesScreen({super.key, required this.onSelectProject});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;
        final focusProject = state.currentFocusProject;
        final otherProjects = state.projects.where((p) => p.id != focusProject?.id).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Attention & Priorities", style: MarginTypography.headingMedium),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Margo Attention Banner
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF4EC), Color(0xFFF6F0FF)],
                      ),
                      borderRadius: MarginRadii.cardRadius,
                      border: Border.all(color: MarginColors.softPeach),
                    ),
                    child: Row(
                      children: [
                        const MargoWidget(mood: MargoMood.thinking, size: 68),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Attention Insights 🔥",
                                style: MarginTypography.headingSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Based on imminent deadlines, high progress momentum, and team impact.",
                                style: MarginTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current Focus Project Card
                  Text("Current Primary Focus", style: MarginTypography.headingSmall),
                  const SizedBox(height: 10),
                  if (focusProject != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: MarginColors.surfaceWhite,
                        borderRadius: MarginRadii.cardRadius,
                        border: Border.all(color: MarginColors.purple, width: 2),
                        boxShadow: MarginShadows.floating,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MarginColors.purple.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.bolt_rounded, color: MarginColors.purple, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Focus on ${focusProject.name}",
                                      style: MarginTypography.headingSmall,
                                    ),
                                    Text(
                                      "${(focusProject.progress * 100).toInt()}% complete • Due in 2 days",
                                      style: MarginTypography.caption.copyWith(color: MarginColors.purple),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => onSelectProject(focusProject),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MarginColors.purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                child: const Text("View →"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(focusProject.description, style: MarginTypography.bodyMedium),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: focusProject.progress,
                              backgroundColor: MarginColors.surfaceWarm,
                              valueColor: const AlwaysStoppedAnimation<Color>(MarginColors.purple),
                              minHeight: 7,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  // Other Active Projects (User can tap to make any project their focus!)
                  Text("Other Active Workstreams", style: MarginTypography.headingSmall),
                  const SizedBox(height: 12),
                  ...otherProjects.map((p) {
                    final color = Color(p.colorValue);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: MarginColors.surfaceWhite,
                          borderRadius: MarginRadii.cardRadius,
                          border: Border.all(color: MarginColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.folder_outlined, color: color, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: MarginTypography.bodyMediumBold),
                                  Text(
                                    "Next: ${p.nextMilestone}",
                                    style: MarginTypography.caption,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                state.setFocusProject(p.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Switched active focus to '${p.name}'")),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: const Text("Set Focus"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
