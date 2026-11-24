import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/journal_entry_card.dart';
import '../../shared/components/empty_state.dart';

class JournalScreen extends StatefulWidget {
  final ValueChanged<JournalEntry> onSelectEntry;
  final ValueChanged<JournalEntry> onAnalyzeEntry;
  final VoidCallback onNewEntry;

  const JournalScreen({
    super.key,
    required this.onSelectEntry,
    required this.onAnalyzeEntry,
    required this.onNewEntry,
  });

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _selectedFilter = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ["All", "Voice", "Analyzed", "Projects", "Drafts"];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        // Apply filters
        var entries = state.journalEntries.where((entry) {
          if (_searchQuery.isNotEmpty) {
            final matchesSearch = entry.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                entry.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                entry.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
            if (!matchesSearch) return false;
          }

          if (_selectedFilter == "Voice") {
            return entry.isVoice;
          } else if (_selectedFilter == "Analyzed") {
            return entry.isAnalyzed;
          } else if (_selectedFilter == "Projects") {
            return entry.linkedProjectId != null;
          } else if (_selectedFilter == "Drafts") {
            return entry.isDraft;
          }
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Journal Library", style: MarginTypography.headingMedium),
            actions: [
              IconButton(
                onPressed: widget.onNewEntry,
                icon: const Icon(Icons.edit_note_rounded, color: MarginColors.purple, size: 28),
                tooltip: "New Thought",
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search thoughts, tags, or projects...",
                      prefixIcon: const Icon(Icons.search_rounded, color: MarginColors.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      fillColor: MarginColors.surfaceWhite,
                    ),
                  ),
                ),

                // Filter Chips
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;

                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                        },
                        selectedColor: MarginColors.purple,
                        backgroundColor: MarginColors.surfaceWhite,
                        labelStyle: MarginTypography.chip.copyWith(
                          color: isSelected ? Colors.white : MarginColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected ? MarginColors.purple : MarginColors.borderLight,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: MarginRadii.pillRadius),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Entries list or Empty State
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: EmptyStateWidget(
                            type: EmptyStateType.emptyJournal,
                            actionLabel: "Capture a thought",
                            onActionTap: widget.onNewEntry,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                          itemCount: entries.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return JournalEntryCard(
                              entry: entry,
                              onTap: () => widget.onSelectEntry(entry),
                              onAnalyzeTap: () => widget.onAnalyzeEntry(entry),
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
