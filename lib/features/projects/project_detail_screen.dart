import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/task_tile.dart';
import '../../shared/components/member_avatar_stack.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final VoidCallback onOpenBlueprint;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.onOpenBlueprint,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;
        final color = Color(widget.project.colorValue);
        final projectTasks = state.tasks.where((t) => t.projectId == widget.project.id).toList();
        final linkedJournals = state.journalEntries.where((j) => j.linkedProjectId == widget.project.id).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text(widget.project.name, style: MarginTypography.headingMedium),
            actions: [
              IconButton(
                icon: const Icon(Icons.architecture_rounded, color: MarginColors.purple),
                tooltip: "View Blueprint",
                onPressed: widget.onOpenBlueprint,
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: MarginColors.purple,
              labelColor: MarginColors.purple,
              unselectedLabelColor: MarginColors.textMuted,
              labelStyle: MarginTypography.chip,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Tasks"),
                Tab(text: "Journal"),
                Tab(text: "Decisions"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // 1. Overview Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header progress card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: MarginColors.surfaceWhite,
                        borderRadius: MarginRadii.cardRadius,
                        border: Border.all(color: MarginColors.borderLight, width: 1.2),
                        boxShadow: MarginShadows.card,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.project.category,
                                  style: MarginTypography.caption.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ),
                              Text(
                                "${(widget.project.progress * 100).toInt()}% Done",
                                style: MarginTypography.bodyMediumBold.copyWith(color: color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(widget.project.description, style: MarginTypography.bodyLarge),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: widget.project.progress,
                              backgroundColor: MarginColors.surfaceWarm,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.flag_rounded, size: 16, color: MarginColors.textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Next milestone: ${widget.project.nextMilestone}",
                                  style: MarginTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Team Members
                    Text("Team Members", style: MarginTypography.headingSmall),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MarginColors.surfaceWhite,
                        borderRadius: MarginRadii.cardRadius,
                        border: Border.all(color: MarginColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          MemberAvatarStack(members: state.teamMembers, avatarSize: 36),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${state.teamMembers.length} active collaborators", style: MarginTypography.bodyMediumBold),
                                Text("Shared decisions & task tracking", style: MarginTypography.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Blueprint Banner
                    InkWell(
                      onTap: widget.onOpenBlueprint,
                      borderRadius: MarginRadii.cardRadius,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF3EFFF), Color(0xFFFFF7EE)],
                          ),
                          borderRadius: MarginRadii.cardRadius,
                          border: Border.all(color: MarginColors.lavenderSoft),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.architecture_rounded, color: MarginColors.purple, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("View Strategic Blueprint", style: MarginTypography.headingSmall.copyWith(fontSize: 16)),
                                  Text("Review AI-synthesized scope, goals, and mitigations", style: MarginTypography.caption),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: MarginColors.purple),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Tasks Tab
              projectTasks.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text("No tasks in this project yet", style: MarginTypography.bodyMedium),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: projectTasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = projectTasks[index];
                        return TaskTile(
                          task: task,
                          onToggle: () => state.toggleTaskCompletion(task.id),
                        );
                      },
                    ),

              // 3. Journal Tab
              linkedJournals.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text("No journal thoughts linked yet", style: MarginTypography.bodyMedium),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: linkedJournals.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final j = linkedJournals[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: MarginColors.surfaceWhite,
                            borderRadius: MarginRadii.cardRadius,
                            border: Border.all(color: MarginColors.borderLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(j.title, style: MarginTypography.headingSmall),
                              const SizedBox(height: 6),
                              Text(j.content, style: MarginTypography.bodyMedium),
                            ],
                          ),
                        );
                      },
                    ),

              // 4. Decisions Tab
              widget.project.decisions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text("No decisions recorded yet", style: MarginTypography.bodyMedium),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: widget.project.decisions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final decision = widget.project.decisions[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: MarginColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: MarginColors.borderLight),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 18, color: MarginColors.success),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(decision, style: MarginTypography.bodyMedium),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
