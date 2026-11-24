import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const Spacer(),
              const MargoWidget(
                mood: MargoMood.excited,
                size: 130,
              ),
              const SizedBox(height: 32),
              Text(
                "Your thoughts\ndeserve somewhere to go.",
                textAlign: TextAlign.center,
                style: MarginTypography.displayMedium.copyWith(
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Write, dictate, or save any thought in the moment. MARGIN gently helps you discover meaning and turn inspiration into next steps.",
                textAlign: TextAlign.center,
                style: MarginTypography.bodyLarge.copyWith(
                  color: MarginColors.textSecondary,
                ),
              ),
              const Spacer(),
              // CTA Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                  ),
                  child: const Text("Get started"),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onLogin,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                  ),
                  child: const Text("I already have an account"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
