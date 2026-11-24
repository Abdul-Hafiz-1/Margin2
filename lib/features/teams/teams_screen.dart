import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/member_avatar_stack.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class TeamsScreen extends StatefulWidget {
  final VoidCallback onInviteTap;

  const TeamsScreen({super.key, required this.onInviteTap});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final state = StateService.instance;
    state.addTeamMessage(
      TeamMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: state.userName,
        message: text,
        timestamp: DateTime.now(),
      ),
    );
    _chatController.clear();
  }

  void _askMargoForTeam() {
    final state = StateService.instance;
    state.addTeamMessage(
      TeamMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: "Margo",
        message: "Here are 3 key action steps to align the team this week:",
        timestamp: DateTime.now(),
        isFromMargo: true,
        suggestions: [
          "Confirm cotton weight with garment supplier",
          "Review font options for neck label",
          "Finalize photography styleguide for launch",
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService.instance,
      builder: (context, _) {
        final state = StateService.instance;

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Team Collaboration", style: MarginTypography.headingMedium),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined, color: MarginColors.purple),
                tooltip: "Invite Members",
                onPressed: widget.onInviteTap,
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
                Tab(text: "Discussion"),
                Tab(text: "Members"),
                Tab(text: "Shared Files"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // 1. Discussion & Margo Suggestions Tab
              Column(
                children: [
                  // Team Header Card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: MarginColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: MarginColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MarginColors.lavenderSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.group_rounded, color: MarginColors.purple, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("MARGIN Core Team", style: MarginTypography.bodyMediumBold),
                              Text("4 members • Active workspace", style: MarginTypography.caption),
                            ],
                          ),
                        ),
                        MemberAvatarStack(members: state.teamMembers, avatarSize: 28),
                      ],
                    ),
                  ),

                  // Ask Margo Button Pill
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: InkWell(
                      onTap: _askMargoForTeam,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: MarginColors.lavenderGhost,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome_rounded, color: MarginColors.purple, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              "Let's ask Margo for suggestions!",
                              style: MarginTypography.caption.copyWith(
                                color: MarginColors.purpleDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Chat Message List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: state.teamMessages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final msg = state.teamMessages[index];
                        return _buildChatBubble(msg);
                      },
                    ),
                  ),

                  // Chat Input Bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    decoration: BoxDecoration(
                      color: MarginColors.surfaceWhite,
                      border: const Border(top: BorderSide(color: MarginColors.borderLight)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: const InputDecoration(
                              hintText: "Type a message or proposal...",
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (_) => _sendChatMessage(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filled(
                          onPressed: _sendChatMessage,
                          style: IconButton.styleFrom(backgroundColor: MarginColors.purple),
                          icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Members Tab
              ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.teamMembers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = state.teamMembers[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MarginColors.surfaceWhite,
                      borderRadius: MarginRadii.cardRadius,
                      border: Border.all(color: MarginColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(member.colorValue),
                          child: Text(
                            member.name.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name, style: MarginTypography.bodyMediumBold),
                              Text(member.role, style: MarginTypography.caption),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: MarginColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            member.role == "Owner" ? "Owner" : "Editor",
                            style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 3. Shared Files Tab
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildFileTile("T-shirt_Tech_Pack_v2.pdf", "8.4 MB • Updated yesterday"),
                    const SizedBox(height: 10),
                    _buildFileTile("MARGIN_Brand_Identity.fig", "14.2 MB • Updated 3 days ago"),
                    const SizedBox(height: 10),
                    _buildFileTile("Manufacturer_Quotes.xlsx", "1.1 MB • Updated 5 days ago"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(TeamMessage msg) {
    if (msg.isFromMargo) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MarginColors.lavenderGhost,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const MargoWidget(mood: MargoMood.organizing, size: 36),
                const SizedBox(width: 8),
                Text(
                  "Margo (AI Companion)",
                  style: MarginTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MarginColors.purpleDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(msg.message, style: MarginTypography.bodyMediumBold),
            if (msg.suggestions != null) ...[
              const SizedBox(height: 10),
              ...msg.suggestions!.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Icon(Icons.circle, size: 6, color: MarginColors.purple),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s, style: MarginTypography.bodyMedium)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      );
    }

    final isMe = msg.sender == StateService.instance.userName;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? MarginColors.purple : MarginColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: isMe ? null : Border.all(color: MarginColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                msg.sender,
                style: MarginTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: MarginColors.textSecondary,
                ),
              ),
            Text(
              msg.message,
              style: MarginTypography.bodyMedium.copyWith(
                color: isMe ? Colors.white : MarginColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTile(String name, String meta) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MarginColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MarginColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: MarginColors.purple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: MarginTypography.bodyMediumBold),
                Text(meta, style: MarginTypography.caption),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: MarginColors.textSecondary, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
