import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const SplashScreen({super.key, required this.onContinue});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        widget.onContinue();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: MarginColors.splashGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Floating Margo
              const MargoWidget(
                mood: MargoMood.idle,
                size: 150,
              ),
              const SizedBox(height: 28),
              // MARGIN Wordmark
              Text(
                "MARGIN",
                style: MarginTypography.displayLarge.copyWith(
                  letterSpacing: 3,
                  fontWeight: FontWeight.w800,
                  color: MarginColors.purpleDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Think freely. Make things happen.",
                style: MarginTypography.bodyLarge.copyWith(
                  color: MarginColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              // Progress indicator
              SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    backgroundColor: Color(0xFFE2DBFF),
                    valueColor: AlwaysStoppedAnimation<Color>(MarginColors.purple),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
