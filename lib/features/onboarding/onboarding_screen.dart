import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      "mood": MargoMood.listening,
      "title": "Capture anything",
      "subtitle": "Ideas, reflections, fleeting thoughts, or audio memos. Speak freely without worrying about neatness.",
    },
    {
      "mood": MargoMood.thinking,
      "title": "Make sense of it",
      "subtitle": "Discover hidden tasks, recurring themes, and strategic opportunities through hybrid intelligence.",
    },
    {
      "mood": MargoMood.organizing,
      "title": "Make it happen",
      "subtitle": "Structure your projects, schedule clear milestones, and invite collaborators whenever you're ready.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];

    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: widget.onFinish,
            child: Text(
              "Skip",
              style: MarginTypography.bodyMediumBold.copyWith(color: MarginColors.purple),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const Spacer(),
              // Margo expressing the current slide's mood
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: MargoWidget(
                  key: ValueKey(_currentIndex),
                  mood: slide["mood"] as MargoMood,
                  size: 140,
                ),
              ),
              const SizedBox(height: 36),
              // Slide Title & Subtitle
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey(_currentIndex),
                  children: [
                    Text(
                      slide["title"] as String,
                      textAlign: TextAlign.center,
                      style: MarginTypography.displayMedium,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      slide["subtitle"] as String,
                      textAlign: TextAlign.center,
                      style: MarginTypography.bodyLarge.copyWith(
                        color: MarginColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Page Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (idx) {
                  final active = idx == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? MarginColors.purple : MarginColors.lavender,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Next / Get Started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < _slides.length - 1) {
                      setState(() {
                        _currentIndex++;
                      });
                    } else {
                      widget.onFinish();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentIndex == _slides.length - 1 ? "Get started" : "Next",
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
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
