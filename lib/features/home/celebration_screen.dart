import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class CelebrationScreen extends StatelessWidget {
  final VoidCallback onDismiss;

  const CelebrationScreen({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE2D7FF), Color(0xFFF9F7FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Margo Celebrating
                const MargoWidget(
                  mood: MargoMood.celebrating,
                  size: 160,
                ),

                const SizedBox(height: 32),

                Text(
                  "You did it!",
                  style: MarginTypography.displayLarge.copyWith(
                    color: MarginColors.purpleDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "A major step towards your goals.",
                  style: MarginTypography.bodyLarge.copyWith(
                    color: MarginColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 28),

                // Achievement Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: MarginRadii.cardRadius,
                    boxShadow: MarginShadows.card,
                    border: Border.all(color: MarginColors.lavenderSoft),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: MarginColors.mintLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: MarginColors.success, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("MARGIN Milestone Complete", style: MarginTypography.bodyMediumBold),
                            Text("+5 productive focus days", style: MarginTypography.caption.copyWith(color: MarginColors.success)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarginColors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Keep Going"),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
