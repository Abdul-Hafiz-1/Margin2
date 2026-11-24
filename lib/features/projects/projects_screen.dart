import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/project_card.dart';
import '../../shared/components/empty_state.dart';

class ProjectsScreen extends StatefulWidget {
  final ValueChanged<Project> onSelectProject;
  final VoidCallback onCreateProject;

  const ProjectsScreen({
    super.key,
    required this.onSelectProject,
    required this.onCreateProject,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedFilter = "All";
  String _searchQuery = "";
  final List<String> _filters = ["All", "Active", "Archived"];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        final projects = state.projects.where((p) {
          if (_searchQuery.isNotEmpty) {
            final matches = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.category.toLowerCase().contains(_searchQuery.toLowerCase());
            if (!matches) return false;
          }

          if (_selectedFilter == "Active") return !p.isArchived;
          if (_selectedFilter == "Archived") return p.isArchived;
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Projects", style: MarginTypography.headingMedium),
            actions: [
              IconButton(
                onPressed: widget.onCreateProject,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: MarginColors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                ),
                tooltip: "New Project",
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search & Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: const InputDecoration(
                      hintText: "Search projects...",
                      prefixIcon: Icon(Icons.search_rounded, color: MarginColors.textMuted),
                      fillColor: MarginColors.surfaceWhite,
                    ),
                  ),
                ),

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
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

                const SizedBox(height: 10),

                // List
                Expanded(
                  child: projects.isEmpty
                      ? Center(
                          child: EmptyStateWidget(
                            type: EmptyStateType.noProjects,
                            actionLabel: "Create Project",
                            onActionTap: widget.onCreateProject,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                          itemCount: projects.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final proj = projects[index];
                            return ProjectCard(
                              project: proj,
                              onTap: () => widget.onSelectProject(proj),
                            );
                          },
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
