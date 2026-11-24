import 'package:flutter/material.dart';
import '../../core/services/state_service.dart';
import '../../core/services/inference_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onShowCelebration;

  const SettingsScreen({super.key, required this.onShowCelebration});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appearance = "Light";

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([StateService.instance, InferenceService.instance]),
      builder: (context, _) {
        final state = StateService.instance;
        final inference = InferenceService.instance;

        return Scaffold(
          backgroundColor: MarginColors.cream,
          appBar: AppBar(
            title: Text("Settings & Profile", style: MarginTypography.headingMedium),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: MarginColors.surfaceWhite,
                    borderRadius: MarginRadii.cardRadius,
                    border: Border.all(color: MarginColors.borderLight, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: MarginColors.purple,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          state.userName.substring(0, 1).toUpperCase(),
                          style: MarginTypography.headingLarge.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.userName, style: MarginTypography.headingSmall),
                            Text(state.userEmail, style: MarginTypography.caption),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: MarginColors.lavenderGhost,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                state.workspaceName,
                                style: MarginTypography.caption.copyWith(color: MarginColors.purpleDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Appearance
                Text("Appearance", style: MarginTypography.headingSmall),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MarginColors.surfaceWhite,
                    borderRadius: MarginRadii.cardRadius,
                    border: Border.all(color: MarginColors.borderLight),
                  ),
                  child: Row(
                    children: ["Light", "Dark", "Auto"].map((mode) {
                      final isSel = _appearance == mode;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InkWell(
                            onTap: () => setState(() => _appearance = mode),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? MarginColors.purple : MarginColors.surfaceWarm,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                mode,
                                style: MarginTypography.chip.copyWith(
                                  color: isSel ? Colors.white : MarginColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // AI Preferences (Hybrid AI UX)
                Text("AI Preferences (Hybrid Inference)", style: MarginTypography.headingSmall),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: MarginColors.surfaceWhite,
                    borderRadius: MarginRadii.cardRadius,
                    border: Border.all(color: MarginColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text("Use Local AI when possible", style: MarginTypography.bodyMediumBold),
                        subtitle: Text(
                          "Basic thoughts & task extraction stay privately on-device.",
                          style: MarginTypography.caption,
                        ),
                        activeTrackColor: MarginColors.purple,
                        value: inference.preferLocal,
                        onChanged: (val) => inference.setPreferLocal(val),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: Text("Cloud Deep Strategy Consent", style: MarginTypography.bodyMediumBold),
                        subtitle: Text(
                          "Enables complex project blueprints & cross-team reasoning.",
                          style: MarginTypography.caption,
                        ),
                        activeTrackColor: MarginColors.purple,
                        value: inference.hasCloudConsent,
                        onChanged: (val) => inference.setCloudConsent(val),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.shield_outlined, color: MarginColors.success),
                        title: Text("Privacy: Your data stays on device", style: MarginTypography.bodyMediumBold),
                        subtitle: Text("Encrypted offline storage with selective cloud sync.", style: MarginTypography.caption),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Demo Celebration Trigger
                Text("Milestone Celebration Preview", style: MarginTypography.headingSmall),
                const SizedBox(height: 10),
                InkWell(
                  onTap: widget.onShowCelebration,
                  borderRadius: MarginRadii.cardRadius,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEDE7FF), Color(0xFFFFF0EC)],
                      ),
                      borderRadius: MarginRadii.cardRadius,
                      border: Border.all(color: MarginColors.lavenderSoft),
                    ),
                    child: Row(
                      children: [
                        const MargoWidget(mood: MargoMood.celebrating, size: 48),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Preview Celebration Screen", style: MarginTypography.bodyMediumBold),
                              Text("See Margo celebrate completed milestone goals!", style: MarginTypography.caption),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: MarginColors.purple),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // About MARGIN
                Text("About MARGIN", style: MarginTypography.headingSmall),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MarginColors.surfaceWhite,
                    borderRadius: MarginRadii.cardRadius,
                    border: Border.all(color: MarginColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Version", style: MarginTypography.bodyMedium),
                          Text("1.0.0 (Production Release)", style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Design System", style: MarginTypography.bodyMedium),
                          Text("MARGIN Pastel Soft Intelligence", style: MarginTypography.caption.copyWith(color: MarginColors.purple)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
