import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../margo/margo_widget.dart';
import '../margo/margo_states.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final ValueChanged<String> onFinished;
  final VoidCallback onCancelled;

  const VoiceRecorderWidget({
    super.key,
    required this.onFinished,
    required this.onCancelled,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _timer;
  int _seconds = 0;
  bool _isPaused = false;

  final List<String> _samplePhrases = [
    "I've been thinking about starting a clothing brand...",
    "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts...",
    "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts. I need to research manufacturers, understand the costs...",
    "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts. I need to research manufacturers, understand the costs, create a logo, and discuss it with my friends. I don't really know where to start.",
  ];
  int _phraseIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          _seconds++;
          if (_seconds % 2 == 0 && _phraseIndex < _samplePhrases.length - 1) {
            _phraseIndex++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final transcription = _samplePhrases[_phraseIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MarginColors.surface,
        borderRadius: MarginRadii.sheetRadius,
        border: const Border(top: BorderSide(color: MarginColors.borderLight, width: 1.0)),
        boxShadow: MarginShadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MarginColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Margo in listening mode with headphones
          const MargoWidget(
            mood: MargoMood.listening,
            size: 80,
            showSpeechBubble: true,
            customSpeech: "Listening closely...",
          ),
          const SizedBox(height: 16),

          // Timer and live indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isPaused ? MarginColors.warning : MarginColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(_seconds),
                style: MarginTypography.headingMedium.copyWith(
                  color: MarginColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isPaused ? "(Paused)" : "(Listening)",
                style: MarginTypography.caption.copyWith(
                  color: MarginColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Animated Audio Waveform
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              return SizedBox(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    progress: _animController.value,
                    isPaused: _isPaused,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Live Transcription Bubble
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: MarginColors.elevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MarginColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 14, color: MarginColors.lavender),
                    const SizedBox(width: 6),
                    Text(
                      "Live Speech-to-Text Transcription",
                      style: MarginTypography.caption.copyWith(
                        color: MarginColors.lavender,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  transcription,
                  style: MarginTypography.bodyMedium.copyWith(
                    color: MarginColors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Controls: Cancel, Pause/Resume, Finish
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                onPressed: widget.onCancelled,
                style: IconButton.styleFrom(
                  backgroundColor: MarginColors.elevated,
                  padding: const EdgeInsets.all(14),
                ),
                icon: const Icon(Icons.close_rounded, color: MarginColors.textSecondary),
                tooltip: "Cancel",
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _isPaused = !_isPaused;
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: MarginColors.elevated,
                  padding: const EdgeInsets.all(16),
                ),
                icon: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: MarginColors.butter,
                  size: 28,
                ),
                tooltip: _isPaused ? "Resume" : "Pause",
              ),
              ElevatedButton.icon(
                onPressed: () => widget.onFinished(transcription),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarginColors.lavender,
                  foregroundColor: MarginColors.background,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.check_rounded, size: 20),
                label: const Text("Finish & Review"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;
  final bool isPaused;

  _WaveformPainter({required this.progress, required this.isPaused});

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = 28;
    final barWidth = (size.width - (barCount * 4)) / barCount;
    final midY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + 4);
      double barHeight;

      if (isPaused) {
        barHeight = 4.0;
      } else {
        final phase = (i / barCount) * 2 * math.pi;
        final wave = math.sin((progress * 2 * math.pi) + phase);
        final heightMultiplier = (math.sin(i / barCount * math.pi));
        barHeight = (10 + (wave.abs() * 32)) * heightMultiplier;
      }

      final paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MarginColors.lavender,
            MarginColors.peach,
          ],
        ).createShader(Rect.fromLTWH(x, midY - barHeight / 2, barWidth, barHeight))
        ..strokeCap = StrokeCap.round;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, midY - barHeight / 2, barWidth, barHeight),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isPaused != isPaused;
  }
}
