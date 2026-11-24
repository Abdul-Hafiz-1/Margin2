import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'margo_states.dart';

class MargoWidget extends StatefulWidget {
  final MargoMood mood;
  final double size;
  final bool showSpeechBubble;
  final String? customSpeech;
  final bool isListening;
  final bool isProcessing;
  final double? progress;
  final VoidCallback? onTap;

  const MargoWidget({
    super.key,
    this.mood = MargoMood.idle,
    this.size = 100,
    this.showSpeechBubble = false,
    this.customSpeech,
    this.isListening = false,
    this.isProcessing = false,
    this.progress,
    this.onTap,
  });

  @override
  State<MargoWidget> createState() => _MargoWidgetState();
}

class _MargoWidgetState extends State<MargoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MargoMood _resolveActiveMood() {
    if (widget.isListening) return MargoMood.listening;
    if (widget.isProcessing) return MargoMood.processing;
    return widget.mood;
  }

  @override
  Widget build(BuildContext context) {
    final activeMood = _resolveActiveMood();
    final speechText = widget.customSpeech ??
        MargoStateConfig.configs[activeMood]?.speechText ??
        "";

    Widget margoGraphic = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Floating loop & breathing modulation
        final floatMagnitude = activeMood == MargoMood.sleeping ? 0.02 : 0.06;
        final floatOffset = math.sin(t * 2 * math.pi) * (widget.size * floatMagnitude);
        final rotateAngle = math.sin(t * 2 * math.pi * 0.5) * 0.04;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.rotate(
            angle: rotateAngle,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _MargoRivePainter(
                  mood: activeMood,
                  progress: t,
                  aiProgress: widget.progress,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.onTap != null) {
      margoGraphic = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: margoGraphic,
      );
    }

    if (!widget.showSpeechBubble || speechText.isEmpty) {
      return margoGraphic;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        margoGraphic,
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 240),
          decoration: BoxDecoration(
            color: MarginColors.elevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MarginColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            speechText,
            textAlign: TextAlign.center,
            style: MarginTypography.bodySmall.copyWith(
              color: MarginColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _MargoRivePainter extends CustomPainter {
  final MargoMood mood;
  final double progress;
  final double? aiProgress;

  _MargoRivePainter({
    required this.mood,
    required this.progress,
    this.aiProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.52);
    final radius = size.width * 0.32;

    // 1. Midnight Bloom Luminous Ambient Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          MarginColors.lavender.withValues(alpha: 0.22),
          MarginColors.peach.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.6));
    canvas.drawCircle(center, radius * 1.6, glowPaint);

    // 2. Back half of the orbiting iridescent ribbon
    _drawOrbitRibbon(canvas, center, radius, isBack: true);

    // 3. Pear-cloud body silhouette
    final bodyPath = Path();
    final bodyTop = center.dy - radius * 0.95;
    final bodyBottom = center.dy + radius * 1.05;
    final bodyLeft = center.dx - radius * 0.95;
    final bodyRight = center.dx + radius * 0.95;

    bodyPath.moveTo(center.dx, bodyTop);
    bodyPath.cubicTo(
      bodyRight + radius * 0.1, bodyTop + radius * 0.4,
      bodyRight + radius * 0.2, bodyBottom - radius * 0.2,
      center.dx, bodyBottom,
    );
    bodyPath.cubicTo(
      bodyLeft - radius * 0.2, bodyBottom - radius * 0.2,
      bodyLeft - radius * 0.1, bodyTop + radius * 0.4,
      center.dx, bodyTop,
    );

    // Body Gradient: Pearlescent soft cream on dark charcoal background
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF7F5FC),
          Color(0xFFE2DDF5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.1))
      ..style = PaintingStyle.fill;

    canvas.drawShadow(bodyPath, Colors.black.withValues(alpha: 0.35), 10, false);
    canvas.drawPath(bodyPath, bodyPaint);

    // Little cute left & right arms
    final armPaint = Paint()
      ..color = const Color(0xFFF2EDFC)
      ..style = PaintingStyle.fill;

    double leftArmY = center.dy + radius * 0.25;
    double rightArmY = center.dy + radius * 0.25;
    if (mood == MargoMood.celebrating || mood == MargoMood.ideaFound) {
      leftArmY -= radius * 0.35;
      rightArmY -= radius * 0.35;
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.82, leftArmY),
        width: radius * 0.35,
        height: radius * 0.28,
      ),
      armPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.82, rightArmY),
        width: radius * 0.35,
        height: radius * 0.28,
      ),
      armPaint,
    );

    // 4. Rosy Blush Cheeks (Midnight Bloom Peach)
    final blushPaint = Paint()
      ..color = MarginColors.peach.withValues(alpha: 0.75)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.48, center.dy + radius * 0.18),
        width: radius * 0.28,
        height: radius * 0.18,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.48, center.dy + radius * 0.18),
        width: radius * 0.28,
        height: radius * 0.18,
      ),
      blushPaint,
    );

    // 5. Facial Expressions (Rive State Machine)
    _drawFace(canvas, center, radius);

    // 6. Mode Accessories
    if (mood == MargoMood.listening) {
      _drawHeadphones(canvas, center, radius);
    } else if (mood == MargoMood.thinking || mood == MargoMood.processing || mood == MargoMood.organizing) {
      _drawThinkingParticles(canvas, center, radius);
    } else if (mood == MargoMood.celebrating) {
      _drawCelebrationSparks(canvas, center, radius);
    } else if (mood == MargoMood.error) {
      _drawErrorState(canvas, center, radius);
    }

    // 7. Front half of the orbiting iridescent ribbon
    _drawOrbitRibbon(canvas, center, radius, isBack: false);
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()
      ..color = const Color(0xFF1E1B2E)
      ..style = PaintingStyle.fill;

    final mouthPaint = Paint()
      ..color = const Color(0xFF1E1B2E)
      ..strokeWidth = math.max(1.8, radius * 0.05)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final eyeY = center.dy + radius * 0.02;
    final eyeSpacing = radius * 0.35;

    // Blinking logic: 5% of cycle
    final isBlinking = (progress > 0.88 && progress < 0.94);

    if (isBlinking && mood != MargoMood.sleeping && mood != MargoMood.listening) {
      _drawCurvedEye(canvas, Offset(center.dx - eyeSpacing, eyeY), radius * 0.1, true);
      _drawCurvedEye(canvas, Offset(center.dx + eyeSpacing, eyeY), radius * 0.1, true);
      return;
    }

    switch (mood) {
      case MargoMood.idle:
        final leftEyeCenter = Offset(center.dx - eyeSpacing, eyeY);
        final rightEyeCenter = Offset(center.dx + eyeSpacing, eyeY);
        canvas.drawCircle(leftEyeCenter, radius * 0.1, eyePaint);
        canvas.drawCircle(rightEyeCenter, radius * 0.1, eyePaint);

        final hl = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(leftEyeCenter.dx + 2, leftEyeCenter.dy - 2), radius * 0.035, hl);
        canvas.drawCircle(Offset(rightEyeCenter.dx + 2, rightEyeCenter.dy - 2), radius * 0.035, hl);

        final mouthPath = Path();
        mouthPath.moveTo(center.dx - radius * 0.1, eyeY + radius * 0.18);
        mouthPath.quadraticBezierTo(center.dx, eyeY + radius * 0.28, center.dx + radius * 0.1, eyeY + radius * 0.18);
        canvas.drawPath(mouthPath, mouthPaint);
        break;

      case MargoMood.listening:
        _drawCurvedEye(canvas, Offset(center.dx - eyeSpacing, eyeY), radius * 0.12, true);
        _drawCurvedEye(canvas, Offset(center.dx + eyeSpacing, eyeY), radius * 0.12, true);

        final mouthPath = Path();
        mouthPath.moveTo(center.dx - radius * 0.08, eyeY + radius * 0.18);
        mouthPath.quadraticBezierTo(center.dx, eyeY + radius * 0.26, center.dx + radius * 0.08, eyeY + radius * 0.18);
        canvas.drawPath(mouthPath, mouthPaint);
        break;

      case MargoMood.thinking:
      case MargoMood.processing:
      case MargoMood.organizing:
        // Eyes tracking upward to thinking sparkles
        final leftEye = Offset(center.dx - eyeSpacing, eyeY - 2);
        final rightEye = Offset(center.dx + eyeSpacing, eyeY + 1);
        canvas.drawCircle(leftEye, radius * 0.09, eyePaint);
        canvas.drawCircle(rightEye, radius * 0.11, eyePaint);

        final hl = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(leftEye.dx + 1, leftEye.dy - 3), radius * 0.03, hl);
        canvas.drawCircle(Offset(rightEye.dx + 1, rightEye.dy - 2), radius * 0.035, hl);

        canvas.drawCircle(Offset(center.dx, eyeY + radius * 0.2), radius * 0.045, mouthPaint);
        break;

      case MargoMood.ideaFound:
      case MargoMood.excited:
      case MargoMood.celebrating:
        _drawCurvedEye(canvas, Offset(center.dx - eyeSpacing, eyeY), radius * 0.12, true);
        _drawCurvedEye(canvas, Offset(center.dx + eyeSpacing, eyeY), radius * 0.12, true);

        final bigMouth = Path();
        bigMouth.moveTo(center.dx - radius * 0.14, eyeY + radius * 0.16);
        bigMouth.quadraticBezierTo(center.dx, eyeY + radius * 0.38, center.dx + radius * 0.14, eyeY + radius * 0.16);
        bigMouth.close();
        canvas.drawPath(bigMouth, Paint()..color = const Color(0xFFD64D65));
        canvas.drawPath(bigMouth, mouthPaint);
        break;

      case MargoMood.sleeping:
      case MargoMood.resting:
        _drawCurvedEye(canvas, Offset(center.dx - eyeSpacing, eyeY + 2), radius * 0.11, false);
        _drawCurvedEye(canvas, Offset(center.dx + eyeSpacing, eyeY + 2), radius * 0.11, false);

        final mouthPath = Path();
        mouthPath.moveTo(center.dx - radius * 0.07, eyeY + radius * 0.19);
        mouthPath.quadraticBezierTo(center.dx, eyeY + radius * 0.22, center.dx + radius * 0.07, eyeY + radius * 0.19);
        canvas.drawPath(mouthPath, mouthPaint);
        break;

      case MargoMood.error:
        // Confused cute tilted eyebrow and wavy mouth
        canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY - 2), radius * 0.08, eyePaint);
        canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY + 2), radius * 0.11, eyePaint);

        final waveMouth = Path();
        waveMouth.moveTo(center.dx - radius * 0.1, eyeY + radius * 0.22);
        waveMouth.quadraticBezierTo(center.dx - radius * 0.05, eyeY + radius * 0.18, center.dx, eyeY + radius * 0.22);
        waveMouth.quadraticBezierTo(center.dx + radius * 0.05, eyeY + radius * 0.26, center.dx + radius * 0.1, eyeY + radius * 0.22);
        canvas.drawPath(waveMouth, mouthPaint);
        break;
    }
  }

  void _drawCurvedEye(Canvas canvas, Offset center, double size, bool upwards) {
    final eyePaint = Paint()
      ..color = const Color(0xFF1E1B2E)
      ..strokeWidth = math.max(1.8, size * 0.32)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (upwards) {
      path.moveTo(center.dx - size, center.dy + size * 0.2);
      path.quadraticBezierTo(center.dx, center.dy - size * 0.8, center.dx + size, center.dy + size * 0.2);
    } else {
      path.moveTo(center.dx - size, center.dy - size * 0.4);
      path.quadraticBezierTo(center.dx, center.dy + size * 0.6, center.dx + size, center.dy - size * 0.4);
    }
    canvas.drawPath(path, eyePaint);
  }

  void _drawOrbitRibbon(Canvas canvas, Offset center, double radius, {required bool isBack}) {
    canvas.save();
    canvas.translate(center.dx, center.dy - radius * 0.2);
    canvas.rotate(-0.25);

    final ribbonRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2.8,
      height: radius * 0.75,
    );

    final ribbonPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          MarginColors.lavender,
          MarginColors.peach,
          MarginColors.mint,
          MarginColors.butter,
          MarginColors.lavender,
        ],
      ).createShader(ribbonRect)
      ..strokeWidth = math.max(3.0, radius * 0.08)
      ..style = PaintingStyle.stroke;

    if (isBack) {
      canvas.drawArc(ribbonRect, math.pi, math.pi, false, ribbonPaint);
    } else {
      canvas.drawArc(ribbonRect, 0, math.pi, false, ribbonPaint);

      // Rotating sparkle on the front ribbon
      final sparkleAngle = (progress * 2 * math.pi) % math.pi;
      final sx = (radius * 1.4) * math.cos(sparkleAngle);
      final sy = (radius * 0.375) * math.sin(sparkleAngle);

      final sparklePaint = Paint()
        ..color = MarginColors.butter
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(sx, sy), radius * 0.08, sparklePaint);
      canvas.drawCircle(Offset(sx, sy), radius * 0.04, Paint()..color = Colors.white);
    }

    canvas.restore();
  }

  void _drawHeadphones(Canvas canvas, Offset center, double radius) {
    final headBandPaint = Paint()
      ..color = MarginColors.lavender
      ..strokeWidth = math.max(2.5, radius * 0.08)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final headBandPath = Path();
    final topY = center.dy - radius * 0.95;
    headBandPath.moveTo(center.dx - radius * 0.75, center.dy - radius * 0.1);
    headBandPath.cubicTo(
      center.dx - radius * 0.75, topY - radius * 0.2,
      center.dx + radius * 0.75, topY - radius * 0.2,
      center.dx + radius * 0.75, center.dy - radius * 0.1,
    );
    canvas.drawPath(headBandPath, headBandPaint);

    final earcupPaint = Paint()
      ..color = MarginColors.lavenderMuted
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - radius * 0.76, center.dy - radius * 0.05),
          width: radius * 0.25,
          height: radius * 0.45,
        ),
        const Radius.circular(8),
      ),
      earcupPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + radius * 0.76, center.dy - radius * 0.05),
          width: radius * 0.25,
          height: radius * 0.45,
        ),
        const Radius.circular(8),
      ),
      earcupPaint,
    );
  }

  void _drawThinkingParticles(Canvas canvas, Offset center, double radius) {
    final sparkCenter = Offset(center.dx + radius * 0.85, center.dy - radius * 0.9);
    final starPaint = Paint()..color = MarginColors.butter;

    final path = Path();
    final size = radius * 0.15;
    for (int i = 0; i < 8; i++) {
      final r = (i % 2 == 0) ? size : size * 0.4;
      final angle = (i * math.pi / 4) - (math.pi / 2);
      final x = sparkCenter.dx + r * math.cos(angle);
      final y = sparkCenter.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, starPaint);
  }

  void _drawCelebrationSparks(Canvas canvas, Offset center, double radius) {
    final dotPaint = Paint()..style = PaintingStyle.fill;
    dotPaint.color = MarginColors.peach;
    canvas.drawCircle(Offset(center.dx - radius * 0.6, center.dy - radius * 1.1), 3.5, dotPaint);
    dotPaint.color = MarginColors.mint;
    canvas.drawCircle(Offset(center.dx + radius * 0.6, center.dy - radius * 1.1), 3.5, dotPaint);
    dotPaint.color = MarginColors.butter;
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 1.2), 4, dotPaint);
  }

  void _drawErrorState(Canvas canvas, Offset center, double radius) {
    final qCenter = Offset(center.dx + radius * 0.85, center.dy - radius * 0.9);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "?",
        style: TextStyle(
          color: MarginColors.peach,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(qCenter.dx - 6, qCenter.dy - 12));
  }

  @override
  bool shouldRepaint(covariant _MargoRivePainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.progress != progress ||
        oldDelegate.aiProgress != aiProgress;
  }
}
