import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/task_tile.dart';
import '../../shared/components/empty_state.dart';

class TasksScreen extends StatefulWidget {
  final VoidCallback onOpenPriorities;

  const TasksScreen({super.key, required this.onOpenPriorities});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedTab = "All";
  final List<String> _tabs = ["All", "Today", "Upcoming", "Completed"];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        final tasks = state.tasks.where((t) {
          if (_selectedTab == "Completed") return t.isCompleted;
          if (_selectedTab == "Today") {
            if (t.isCompleted) return false;
            if (t.dueDate == null) return false;
            final now = DateTime.now();
            return t.dueDate!.day == now.day && t.dueDate!.month == now.month && t.dueDate!.year == now.year;
          }
          if (_selectedTab == "Upcoming") {
            if (t.isCompleted) return false;
            if (t.dueDate == null) return false;
            final now = DateTime.now();
            return t.dueDate!.isAfter(DateTime(now.year, now.month, now.day, 23, 59));
          }
          return !t.isCompleted;
        }).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Task Management", style: MarginTypography.headingMedium),
            actions: [
              IconButton(
                icon: const Icon(Icons.bolt_rounded, color: MarginColors.purple),
                tooltip: "Attention Insights",
                onPressed: widget.onOpenPriorities,
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, color: MarginColors.purple, size: 28),
                tooltip: "Add Task",
                onPressed: () => _showAddTaskSheet(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Attention Insights quick banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: widget.onOpenPriorities,
                    borderRadius: MarginRadii.cardRadius,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: MarginColors.butterLight,
                        borderRadius: MarginRadii.cardRadius,
                        border: Border.all(color: MarginColors.butter),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Color(0xFFC78400), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Attention Insights",
                                  style: MarginTypography.caption.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8A5A00),
                                  ),
                                ),
                                Text(
                                  "Focus on MARGIN (85% complete, due in 2 days)",
                                  style: MarginTypography.caption.copyWith(color: MarginColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF8A5A00)),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tabs: All, Today, Upcoming, Completed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    children: _tabs.map((tab) {
                      final isSelected = tab == _selectedTab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(tab),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTab = tab);
                            }
                          },
                          selectedColor: MarginColors.purple,
                          backgroundColor: MarginColors.surfaceWhite,
                          labelStyle: MarginTypography.chip.copyWith(
                            color: isSelected ? Colors.white : MarginColors.textSecondary,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: MarginRadii.pillRadius),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // List
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: EmptyStateWidget(
                            type: EmptyStateType.noTasks,
                            actionLabel: "Add a task",
                            onActionTap: () => _showAddTaskSheet(context),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                          itemCount: tasks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskTile(
                              task: task,
                              onToggle: () => state.toggleTaskCompletion(task.id),
                              onTap: () => _showTaskDetail(context, task),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddTaskSheet(context),
            backgroundColor: MarginColors.purple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text("Add Task"),
          ),
        );
      },
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    TaskPriority priority = TaskPriority.medium;
    String? selectedProject = StateService.instance.projects.first.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
                Text("New Task", style: MarginTypography.headingMedium),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "What needs to be done?"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text("Priority:", style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    ...TaskPriority.values.map((p) {
                      final isSel = p == priority;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(p.name.toUpperCase()),
                          selected: isSel,
                          onSelected: (s) {
                            if (s) setSheetState(() => priority = p);
                          },
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        final proj = StateService.instance.projects.firstWhere((pr) => pr.id == selectedProject);
                        StateService.instance.addTask(
                          TaskItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleController.text.trim(),
                            priority: priority,
                            dueDate: DateTime.now(),
                            projectId: proj.id,
                            projectName: proj.name,
                          ),
                        );
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarginColors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Create Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskDetail(BuildContext context, TaskItem task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                Expanded(child: Text(task.title, style: MarginTypography.headingMedium)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (task.projectName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MarginColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("Project: ${task.projectName}", style: MarginTypography.caption),
              ),
            const SizedBox(height: 12),
            Text(
              task.description ?? "No detailed description added.",
              style: MarginTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  StateService.instance.toggleTaskCompletion(task.id);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted ? MarginColors.surfaceWarm : MarginColors.purple,
                  foregroundColor: task.isCompleted ? MarginColors.textPrimary : Colors.white,
                ),
                icon: Icon(task.isCompleted ? Icons.undo_rounded : Icons.check_rounded),
                label: Text(task.isCompleted ? "Mark Incomplete" : "Mark Complete"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
