import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class ProjectBlueprintScreen extends StatefulWidget {
  final JournalEntry entry;

  const ProjectBlueprintScreen({super.key, required this.entry});

  @override
  State<ProjectBlueprintScreen> createState() => _ProjectBlueprintScreenState();
}

class _ProjectBlueprintScreenState extends State<ProjectBlueprintScreen> {
  final Map<String, bool> _approvedSections = {
    "goals": true,
    "scope": true,
    "milestones": false,
    "resources": false,
    "risks": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text("Project Blueprint", style: MarginTypography.headingMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: MarginColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Blueprint link copied to clipboard")),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Margo Hero
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDE7FF), Color(0xFFFFF6EE)],
                  ),
                  borderRadius: MarginRadii.cardRadius,
                  border: Border.all(color: MarginColors.lavenderSoft),
                ),
                child: Row(
                  children: [
                    const MargoWidget(mood: MargoMood.organizing, size: 68),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Strategic Architecture",
                            style: MarginTypography.headingSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Synthesized blueprint for scaling your concept. Review and approve each module.",
                            style: MarginTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 1: Overview & Goals
              _buildBlueprintSection(
                key: "goals",
                title: "1. Core Goals & Purpose",
                icon: Icons.flag_rounded,
                color: MarginColors.purple,
                content: [
                  "Build a sustainable, minimalist streetwear clothing capsule.",
                  "Establish an authentic aesthetic that resonates with creative professionals.",
                  "Achieve positive unit economics with first 100 sample pieces.",
                ],
              ),

              const SizedBox(height: 16),

              // Section 2: Scope & Non-Goals
              _buildBlueprintSection(
                key: "scope",
                title: "2. Scope & Guardrails",
                icon: Icons.check_box_outlined,
                color: MarginColors.info,
                content: [
                  "In Scope: 2 t-shirt colorways (black & raw bone), custom woven tags, landing page.",
                  "Out of Scope: Hoodies, trousers, retail brick-and-mortar stores during Phase 1.",
                ],
              ),

              const SizedBox(height: 16),

              // Section 3: Milestones & Timeline
              _buildBlueprintSection(
                key: "milestones",
                title: "3. Milestones & Timeline",
                icon: Icons.timeline_rounded,
                color: MarginColors.warning,
                content: [
                  "Week 1: Fabric sourcing & manufacturer quotes (Portugal / Turkey).",
                  "Week 2: Tech pack creation & sample run ordering.",
                  "Week 3: Visual identity, typography & brand lookbook shoot.",
                  "Week 4: Launch waitlist landing page & friend pre-orders.",
                ],
              ),

              const SizedBox(height: 16),

              // Section 4: Required Resources & Risk Analysis
              _buildBlueprintSection(
                key: "resources",
                title: "4. Resources & Risk Mitigation",
                icon: Icons.shield_outlined,
                color: MarginColors.error,
                content: [
                  "Estimated Initial Capital: \$1,200 - \$1,800 for first 100 garments.",
                  "Key Risk: Fabric shrinkage after first wash -> Solution: Pre-shrunk cotton spec.",
                  "Key Risk: Minimum Order Quantities too high -> Solution: Partner with boutique printers.",
                ],
              ),

              const SizedBox(height: 28),

              // Summary CTA
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: MarginColors.surfaceWhite,
                  borderRadius: MarginRadii.cardRadius,
                  border: Border.all(color: MarginColors.borderLight),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Approve Blueprint", style: MarginTypography.headingSmall),
                          const SizedBox(height: 2),
                          Text("Lock these approved decisions into your workspace.", style: MarginTypography.caption),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Blueprint saved and linked to your project workspace!"),
                            backgroundColor: MarginColors.purple,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MarginColors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Save Blueprint"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlueprintSection({
    required String key,
    required String title,
    required IconData icon,
    required Color color,
    required List<String> content,
  }) {
    final isApproved = _approvedSections[key] ?? false;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MarginColors.surfaceWhite,
        borderRadius: MarginRadii.cardRadius,
        border: Border.all(
          color: isApproved ? color.withValues(alpha: 0.5) : MarginColors.borderLight,
          width: 1.2,
        ),
        boxShadow: MarginShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: MarginTypography.headingSmall.copyWith(fontSize: 16)),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _approvedSections[key] = !isApproved;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isApproved ? MarginColors.mintLight : MarginColors.surfaceWarm,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isApproved ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        size: 14,
                        color: isApproved ? MarginColors.success : MarginColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isApproved ? "Approved" : "AI Draft",
                        style: MarginTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isApproved ? const Color(0xFF1E8268) : MarginColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.circle, size: 5, color: MarginColors.textMuted),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(point, style: MarginTypography.bodyMedium),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
