import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';
import '../../shared/components/insight_card.dart';
import '../../shared/components/action_plan_card.dart';
import '../../shared/components/confirm_sheet.dart';

class AIInsightsScreen extends StatefulWidget {
  final JournalEntry entry;
  final AIInsight initialInsight;
  final VoidCallback onOpenBlueprint;
  final ValueChanged<Project> onProjectCreated;

  const AIInsightsScreen({
    super.key,
    required this.entry,
    required this.initialInsight,
    required this.onOpenBlueprint,
    required this.onProjectCreated,
  });

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  late AIInsight _insight;
  final TextEditingController _followUpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _insight = widget.initialInsight;
  }

  void _handleToggleTask(int index) {
    setState(() {
      _insight.actionPlan[index].isSelected = !_insight.actionPlan[index].isSelected;
    });
  }

  void _handleRemovePoint(int index) {
    setState(() {
      _insight.keyPoints.removeAt(index);
    });
  }

  void _handleEditPoint(int index, String newText) {
    setState(() {
      _insight.keyPoints[index] = newText;
    });
  }

  Future<void> _handleCreateProject() async {
    final selectedTasks = _insight.actionPlan
        .where((t) => t.isSelected)
        .map((t) => t.title)
        .toList();

    // Confirmation gate: User must approve
    final approved = await ConfirmSheet.show(
      context,
      title: "Create '${_insight.detectedTitle}'?",
      description: "This will create a new project with ${selectedTasks.length} tasks linked to your original thought.",
      itemsToCreate: selectedTasks,
      confirmLabel: "Create Project",
    );

    if (approved == true && mounted) {
      final newProject = Project(
        id: "proj_${DateTime.now().millisecondsSinceEpoch}",
        name: _insight.detectedTitle,
        category: _insight.category.split("/").first.trim(),
        description: _insight.ideaDescription,
        progress: 0.1,
        priority: _insight.priority == "High"
            ? TaskPriority.high
            : TaskPriority.medium,
        nextMilestone: selectedTasks.isNotEmpty ? selectedTasks.first : "Plan initial steps",
        dueDate: DateTime.now().add(const Duration(days: 21)),
        colorValue: MarginColors.purple.toARGB32(),
        iconName: "sparkles",
        decisions: [
          ..._insight.keyPoints.take(2),
        ],
      );

      // Add to StateService
      StateService.instance.addProject(newProject);

      // Add selected tasks
      for (final title in selectedTasks) {
        StateService.instance.addTask(
          TaskItem(
            id: "task_${DateTime.now().millisecondsSinceEpoch}_${title.hashCode}",
            title: title,
            projectId: newProject.id,
            projectName: newProject.name,
            sourceJournalId: widget.entry.id,
            priority: newProject.priority,
            dueDate: DateTime.now().add(const Duration(days: 3)),
          ),
        );
      }

      // Link to original journal entry
      widget.entry.linkedProjectId = newProject.id;
      widget.entry.linkedProjectName = newProject.name;
      widget.entry.isAnalyzed = true;
      widget.entry.insight = _insight;
      StateService.instance.updateJournalEntry(widget.entry);

      // Notify and navigate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Project '${newProject.name}' created with ${selectedTasks.length} tasks!"),
          backgroundColor: MarginColors.purple,
        ),
      );

      widget.onProjectCreated(newProject);
    }
  }

  void _handleAskMargo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: MarginColors.surfaceWhite,
            borderRadius: MarginRadii.sheetRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const MargoWidget(mood: MargoMood.thinking, size: 50),
                  const SizedBox(width: 12),
                  Text("Ask Margo a question", style: MarginTypography.headingSmall),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _followUpController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "e.g. How much fabric do I need for sample tees?",
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Margo: 'Typically 1.5 to 1.8 meters of 280gsm cotton per oversized shirt!'"),
                      ),
                    );
                  },
                  child: const Text("Ask"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text("AI Insights", style: MarginTypography.headingMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Margo friendly greeting banner
              Row(
                children: [
                  const MargoWidget(
                    mood: MargoMood.excited,
                    size: 70,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Here's what I found!",
                          style: MarginTypography.displayMedium.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "I organized your thoughts into key points and a concrete roadmap.",
                          style: MarginTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Insight Card (Idea detection & editable key points)
              InsightCard(
                insight: _insight,
                onRemovePoint: _handleRemovePoint,
                onEditPoint: _handleEditPoint,
              ),

              const SizedBox(height: 20),

              // Action Plan Card (Checklist & project creation)
              ActionPlanCard(
                items: _insight.actionPlan,
                onToggleItem: _handleToggleTask,
                onCreateProject: _handleCreateProject,
                onSaveInsights: () {
                  widget.entry.isAnalyzed = true;
                  widget.entry.insight = _insight;
                  StateService.instance.updateJournalEntry(widget.entry);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Insights saved to journal entry")),
                  );
                },
                onRefinePlan: widget.onOpenBlueprint,
                onAskMargo: _handleAskMargo,
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
