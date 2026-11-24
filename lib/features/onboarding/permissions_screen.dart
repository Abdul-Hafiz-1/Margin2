import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class PermissionsScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const PermissionsScreen({super.key, required this.onContinue});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _notificationsEnabled = true;
  bool _localAiEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text("Privacy & Controls", style: MarginTypography.headingMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                "You are always in control of your thoughts.",
                style: MarginTypography.headingLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "MARGIN is built around mindful privacy. We only request permissions when they directly serve your workflow.",
                style: MarginTypography.bodyMedium,
              ),
              const SizedBox(height: 28),
              // Permission items
              _buildPermissionCard(
                icon: Icons.mic_rounded,
                iconColor: MarginColors.purple,
                title: "Microphone Access",
                description:
                    "Used exclusively for live voice dictation and audio thought memos. We only record when you tap the mic button.",
                isGranted: true,
              ),
              const SizedBox(height: 14),
              _buildSwitchCard(
                icon: Icons.notifications_active_outlined,
                iconColor: MarginColors.warning,
                title: "Gentle Reminders",
                description: "Optional notifications for deadlines you set and quiet reflections.",
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              const SizedBox(height: 14),
              _buildSwitchCard(
                icon: Icons.memory_rounded,
                iconColor: MarginColors.mint,
                title: "Local-First On-Device AI",
                description:
                    "Basic note classification and task extraction run privately on your phone without sending text to the cloud.",
                value: _localAiEnabled,
                onChanged: (val) => setState(() => _localAiEnabled = val),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                  ),
                  child: const Text("Continue"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isGranted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MarginColors.surfaceWhite,
        borderRadius: MarginRadii.cardRadius,
        border: Border.all(color: MarginColors.borderLight, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MarginTypography.headingSmall.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: MarginTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MarginColors.surfaceWhite,
        borderRadius: MarginRadii.cardRadius,
        border: Border.all(color: MarginColors.borderLight, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MarginTypography.headingSmall.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: MarginTypography.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: MarginColors.purple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
