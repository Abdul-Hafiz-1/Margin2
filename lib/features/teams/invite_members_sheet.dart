import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class InviteMembersSheet extends StatefulWidget {
  const InviteMembersSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const InviteMembersSheet(),
    );
  }

  @override
  State<InviteMembersSheet> createState() => _InviteMembersSheetState();
}

class _InviteMembersSheetState extends State<InviteMembersSheet> {
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = "Member";
  final List<String> _roles = ["Admin", "Member", "Viewer"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: MarginColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Invite Team Member", style: MarginTypography.headingMedium),
            const SizedBox(height: 6),
            Text(
              "Collaborators can contribute notes, review milestones, and participate in project decisions.",
              style: MarginTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "colleague@team.com",
                prefixIcon: Icon(Icons.mail_outline_rounded, color: MarginColors.purple),
              ),
            ),
            const SizedBox(height: 16),
            Text("Role & Permissions", style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: _roles.map((role) {
                final isSel = role == _selectedRole;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(role),
                    selected: isSel,
                    onSelected: (s) {
                      if (s) setState(() => _selectedRole = role);
                    },
                    selectedColor: MarginColors.purple,
                    backgroundColor: MarginColors.surfaceWarm,
                    labelStyle: MarginTypography.chip.copyWith(
                      color: isSel ? Colors.white : MarginColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MarginColors.lavenderGhost,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: MarginColors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedRole == "Admin"
                          ? "Admins can manage projects, invite others, and edit all entries."
                          : _selectedRole == "Member"
                              ? "Members can edit tasks and contribute to discussions."
                              : "Viewers have read-only access to milestones and decisions.",
                      style: MarginTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invitation sent! Collaborators receive a secure join link."),
                      backgroundColor: MarginColors.purple,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarginColors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Send Invite"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
