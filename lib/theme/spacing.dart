import 'package:flutter/material.dart';
import 'colors.dart';

class MarginSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double sm = 12.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class MarginRadii {
  static const double button = 16.0;
  static const double input = 16.0;
  static const double card = 20.0;
  static const double cardLarge = 24.0;
  static const double sheet = 28.0;
  static const double pill = 999.0;

  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get inputRadius => BorderRadius.circular(input);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get cardLargeRadius => BorderRadius.circular(cardLarge);
  static BorderRadius get sheetRadius => const BorderRadius.vertical(top: Radius.circular(sheet));
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}

class MarginBorders {
  static Border defaultBorder = Border.all(color: MarginColors.border, width: 1.0);
  static Border lightBorder = Border.all(color: MarginColors.borderLight, width: 1.0);
  static Border subtleBorder = Border.all(color: MarginColors.borderSubtle, width: 1.0);
  static Border activeLavender = Border.all(color: MarginColors.lavender.withValues(alpha: 0.6), width: 1.2);
}

class MarginShadows {
  // Midnight Bloom: restrained, atmospheric, low-opacity ambient glows
  static List<BoxShadow> ambientGlow = [
    BoxShadow(
      color: MarginColors.lavender.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> soft = card;

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 28,
      offset: const Offset(0, 10),
      spreadRadius: -2,
    ),
  ];
}
