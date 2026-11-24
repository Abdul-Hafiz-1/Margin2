import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class GlobalSearchScreen extends StatefulWidget {
  final ValueChanged<Project> onSelectProject;
  final ValueChanged<JournalEntry> onSelectEntry;

  const GlobalSearchScreen({
    super.key,
    required this.onSelectProject,
    required this.onSelectEntry,
  });

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  final List<String> _recentSearches = ["Clothing brand", "YouTube script", "Quicksand typography", "Manufacturers"];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        final matchingJournals = _query.isEmpty
            ? <JournalEntry>[]
            : state.journalEntries.where((j) =>
                j.title.toLowerCase().contains(_query.toLowerCase()) ||
                j.content.toLowerCase().contains(_query.toLowerCase())).toList();

        final matchingProjects = _query.isEmpty
            ? <Project>[]
            : state.projects.where((p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()) ||
                p.description.toLowerCase().contains(_query.toLowerCase())).toList();

        final matchingTasks = _query.isEmpty
            ? <TaskItem>[]
            : state.tasks.where((t) =>
                t.title.toLowerCase().contains(_query.toLowerCase())).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (val) => setState(() => _query = val.trim()),
              decoration: InputDecoration(
                hintText: "Search everything across MARGIN...",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = "");
                        },
                      )
                    : null,
              ),
            ),
          ),
          body: SafeArea(
            child: _query.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Recent Searches", style: MarginTypography.headingSmall),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _recentSearches.map((s) {
                            return ActionChip(
                              label: Text(s),
                              backgroundColor: MarginColors.surfaceWhite,
                              onPressed: () {
                                _searchController.text = s;
                                setState(() => _query = s);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (matchingJournals.isNotEmpty) ...[
                        Text("Journal Thoughts (${matchingJournals.length})", style: MarginTypography.headingSmall),
                        const SizedBox(height: 8),
                        ...matchingJournals.map((j) => ListTile(
                              tileColor: MarginColors.surfaceWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              leading: const Icon(Icons.book_outlined, color: MarginColors.purple),
                              title: Text(j.title, style: MarginTypography.bodyMediumBold),
                              subtitle: Text(j.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () => widget.onSelectEntry(j),
                            )),
                        const SizedBox(height: 20),
                      ],
                      if (matchingProjects.isNotEmpty) ...[
                        Text("Projects (${matchingProjects.length})", style: MarginTypography.headingSmall),
                        const SizedBox(height: 8),
                        ...matchingProjects.map((p) => ListTile(
                              tileColor: MarginColors.surfaceWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              leading: const Icon(Icons.folder_outlined, color: MarginColors.purple),
                              title: Text(p.name, style: MarginTypography.bodyMediumBold),
                              subtitle: Text(p.category),
                              onTap: () => widget.onSelectProject(p),
                            )),
                        const SizedBox(height: 20),
                      ],
                      if (matchingTasks.isNotEmpty) ...[
                        Text("Tasks (${matchingTasks.length})", style: MarginTypography.headingSmall),
                        const SizedBox(height: 8),
                        ...matchingTasks.map((t) => ListTile(
                              tileColor: MarginColors.surfaceWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              leading: const Icon(Icons.check_circle_outline_rounded, color: MarginColors.purple),
                              title: Text(t.title, style: MarginTypography.bodyMediumBold),
                              subtitle: Text(t.projectName ?? "Unassigned"),
                            )),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
