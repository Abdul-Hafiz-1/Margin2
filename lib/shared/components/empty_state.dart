import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../margo/margo_widget.dart';
import '../margo/margo_states.dart';

enum EmptyStateType {
  emptyJournal,
  noTasks,
  noProjects,
  unclearInput,
  completion,
  quiet,
}

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.title,
    this.description,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    MargoMood mood;
    String defaultTitle;
    String defaultDesc;

    switch (type) {
      case EmptyStateType.emptyJournal:
        mood = MargoMood.sleeping;
        defaultTitle = "Your thoughts deserve somewhere to go";
        defaultDesc = "Write, dictate, or save any fleeting spark. MARGIN helps you turn it into progress.";
        break;
      case EmptyStateType.noTasks:
        mood = MargoMood.idle;
        defaultTitle = "All clear for today!";
        defaultDesc = "You have no pending tasks. Enjoy your quiet space or capture a new idea.";
        break;
      case EmptyStateType.noProjects:
        mood = MargoMood.thinking;
        defaultTitle = "No active projects yet";
        defaultDesc = "Turn your journal thoughts into structured projects with milestones and tasks.";
        break;
      case EmptyStateType.unclearInput:
        mood = MargoMood.error;
        defaultTitle = "Could you tell me a little more?";
        defaultDesc = "I want to make sure I understand your intent before proposing next steps.";
        break;
      case EmptyStateType.completion:
        mood = MargoMood.celebrating;
        defaultTitle = "You did it!";
        defaultDesc = "A major step towards your goals. Take a moment to celebrate your momentum.";
        break;
      case EmptyStateType.quiet:
        mood = MargoMood.sleeping;
        defaultTitle = "Quiet Space";
        defaultDesc = "Nothing scheduled right now. Take a deep breath.";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MargoWidget(
            mood: mood,
            size: 110,
          ),
          const SizedBox(height: 20),
          Text(
            title ?? defaultTitle,
            style: MarginTypography.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description ?? defaultDesc,
            style: MarginTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onActionTap != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onActionTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: MarginColors.lavender,
                foregroundColor: MarginColors.background,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
