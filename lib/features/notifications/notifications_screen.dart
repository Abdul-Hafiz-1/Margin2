import 'package:flutter/material.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Notifications & Activity", style: MarginTypography.headingMedium),
            actions: [
              TextButton(
                onPressed: () {
                  for (final n in state.notifications) {
                    state.markNotificationAsRead(n.id);
                  }
                },
                child: Text("Mark all read", style: MarginTypography.caption.copyWith(color: MarginColors.purple)),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: state.notifications.isEmpty
                ? Center(
                    child: Text("No notifications yet", style: MarginTypography.bodyMedium),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = state.notifications[index];

                      IconData icon = Icons.notifications_none_rounded;
                      Color iconColor = MarginColors.purple;
                      if (notif.type == "insight") {
                        icon = Icons.auto_awesome_rounded;
                        iconColor = MarginColors.purple;
                      } else if (notif.type == "deadline") {
                        icon = Icons.timer_outlined;
                        iconColor = MarginColors.warning;
                      } else if (notif.type == "team") {
                        icon = Icons.chat_bubble_outline_rounded;
                        iconColor = MarginColors.info;
                      }

                      return InkWell(
                        onTap: () => state.markNotificationAsRead(notif.id),
                        borderRadius: MarginRadii.cardRadius,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notif.isRead ? MarginColors.surfaceWhite : MarginColors.lavenderGhost,
                            borderRadius: MarginRadii.cardRadius,
                            border: Border.all(
                              color: notif.isRead ? MarginColors.borderLight : MarginColors.lavender,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: iconColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: iconColor, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notif.title, style: MarginTypography.bodyMediumBold),
                                    const SizedBox(height: 2),
                                    Text(notif.subtitle, style: MarginTypography.bodyMedium),
                                    const SizedBox(height: 6),
                                    Text(notif.timeAgo, style: MarginTypography.caption),
                                  ],
                                ),
                              ),
                              if (!notif.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: MarginColors.purple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
