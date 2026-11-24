import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/inference_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../shared/margo/margo_widget.dart';
import '../../shared/margo/margo_states.dart';

class AIAnalysisScreen extends StatefulWidget {
  final JournalEntry entry;
  final ValueChanged<AIInsight> onAnalysisComplete;
  final VoidCallback onCancel;

  const AIAnalysisScreen({
    super.key,
    required this.entry,
    required this.onAnalysisComplete,
    required this.onCancel,
  });

  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  String _currentStage = "Understanding your thoughts...";
  int _stageIndex = 0;
  final List<String> _stages = [
    "Understanding your thoughts...",
    "Finding important points & themes...",
    "Connecting ideas to potential goals...",
    "Preparing useful next steps...",
  ];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() {
    final stream = InferenceService.instance.analyzeThoughtStream(widget.entry.content);
    _subscription = stream.listen((stage) {
      if (mounted) {
        setState(() {
          _currentStage = stage;
          if (_stageIndex < _stages.length - 1) {
            _stageIndex++;
          }
        });

        if (stage == "Ready!") {
          final insight = InferenceService.instance.generateInsightForText(widget.entry.content);
          widget.onAnalysisComplete(insight);
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLocal = InferenceService.instance.preferLocal;

    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: widget.onCancel,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Margo in thinking mood
              const MargoWidget(
                mood: MargoMood.thinking,
                size: 140,
                showSpeechBubble: true,
                customSpeech: "Reflecting on your words...",
              ),

              const SizedBox(height: 36),

              Text(
                "Margo is analysing",
                style: MarginTypography.displayMedium,
              ),

              const SizedBox(height: 12),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _currentStage,
                  key: ValueKey(_currentStage),
                  textAlign: TextAlign.center,
                  style: MarginTypography.bodyLarge.copyWith(
                    color: MarginColors.purpleDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Processing details card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: MarginColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MarginColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLocal ? Icons.bolt_rounded : Icons.cloud_outlined,
                      size: 16,
                      color: MarginColors.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isLocal ? "On-device processing active" : "Cloud model synthesizing",
                      style: MarginTypography.caption.copyWith(
                        color: MarginColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Cancel button
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Cancel"),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
