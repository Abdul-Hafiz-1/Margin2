import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';
import '../../shared/components/thought_capture_card.dart';
import '../../shared/components/project_card.dart';
import '../../shared/components/task_tile.dart';
import '../../shared/components/ai_processing_indicator.dart';

class HomeDashboardScreen extends StatelessWidget {
  final VoidCallback onOpenCapture;
  final VoidCallback onOpenVoiceCapture;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenProfile;
  final ValueChanged<Project> onSelectProject;
  final ValueChanged<JournalEntry> onSelectEntry;
  final VoidCallback onSeeAllProjects;
  final VoidCallback onSeeAllTasks;

  const HomeDashboardScreen({
    super.key,
    required this.onOpenCapture,
    required this.onOpenVoiceCapture,
    required this.onOpenNotifications,
    required this.onOpenProfile,
    required this.onSelectProject,
    required this.onSelectEntry,
    required this.onSeeAllProjects,
    required this.onSeeAllTasks,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING";
    if (hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;
        final greeting = _getGreeting();
        final uncompletedTasks = state.tasks.where((t) => !t.isCompleted).toList();
        final pendingCount = uncompletedTasks.length;

        return Scaffold(
          backgroundColor: MarginColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Editorial App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Identity & Hybrid AI status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "MARGIN",
                                  style: MarginTypography.headingLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: MarginColors.lavender,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const AIProcessingIndicator(),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              greeting,
                              style: MarginTypography.caption.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: MarginColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        // Right: Notification Bell & Profile Avatar
                        Row(
                          children: [
                            IconButton(
                              onPressed: onOpenNotifications,
                              icon: Stack(
                                children: [
                                  const Icon(Icons.notifications_none_rounded, color: MarginColors.textPrimary),
                                  if (state.notifications.any((n) => !n.isRead))
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: MarginColors.peach,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: onOpenProfile,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: MarginColors.elevated,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: MarginColors.borderLight),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.userName.substring(0, 1).toUpperCase(),
                                  style: MarginTypography.button.copyWith(color: MarginColors.lavender),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Midnight Bloom Editorial Motto Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: MarginColors.bloomHeroGradient,
                        borderRadius: MarginRadii.cardRadius,
                        border: Border.all(color: MarginColors.border),
                        boxShadow: MarginShadows.ambientGlow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Make room for what matters.",
                                  style: MarginTypography.headingLarge.copyWith(
                                    fontSize: 20,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  pendingCount > 0
                                      ? "You have $pendingCount important items in focus today."
                                      : "All clear. Thoughts captured here become progress.",
                                  style: MarginTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const MargoWidget(
                            mood: MargoMood.idle,
                            size: 64,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Hero Capture Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ThoughtCaptureCard(
                      onSubmitted: onOpenCapture,
                      onVoiceTap: onOpenVoiceCapture,
                      onAttachTap: onOpenCapture,
                      onQuickTaskTap: () {
                        _showQuickTaskDialog(context);
                      },
                    ),
                  ),
                ),

                // "YOUR WORKSPACE — Projects" Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "YOUR WORKSPACE",
                              style: MarginTypography.caption.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: MarginColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Projects",
                              style: MarginTypography.headingMedium.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: onSeeAllProjects,
                          child: Text(
                            "See all →",
                            style: MarginTypography.chip.copyWith(color: MarginColors.lavender),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Horizontally Scrolling Projects List
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 144,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.projects.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final proj = state.projects[index];
                        return ProjectCard(
                          project: proj,
                          isHorizontalCompact: true,
                          onTap: () => onSelectProject(proj),
                        );
                      },
                    ),
                  ),
                ),

                // "Today's Priorities" Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Today's Focus",
                              style: MarginTypography.headingMedium.copyWith(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: MarginColors.elevated,
                                borderRadius: MarginRadii.pillRadius,
                                border: Border.all(color: MarginColors.borderLight),
                              ),
                              child: Text(
                                "${state.tasks.where((t) => !t.isCompleted).length}",
                                style: MarginTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: MarginColors.lavender,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: onSeeAllTasks,
                          child: Text(
                            "View list →",
                            style: MarginTypography.chip.copyWith(color: MarginColors.lavender),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tasks List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = state.tasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TaskTile(
                            task: task,
                            onToggle: () => state.toggleTaskCompletion(task.id),
                          ),
                        );
                      },
                      childCount: state.tasks.take(4).length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuickTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MarginColors.elevated,
        shape: RoundedRectangleBorder(
          borderRadius: MarginRadii.cardRadius,
          side: const BorderSide(color: MarginColors.border),
        ),
        title: Text("Quick Task", style: MarginTypography.headingSmall),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "What needs to be done?"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: MarginColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                StateService.instance.addTask(
                  TaskItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: controller.text.trim(),
                    dueDate: DateTime.now(),
                    priority: TaskPriority.medium,
                  ),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
