import 'package:flutter/material.dart';

class MarginColors {
  // Midnight Bloom — Core Foundations
  static const Color background = Color(0xFF111114); // Deep charcoal, not pure black
  static const Color surface = Color(0xFF1B1B21);    // Primary card & container surface
  static const Color elevated = Color(0xFF25252D);   // Floating modals, dropdowns, hero inputs
  static const Color surfaceHighlight = Color(0xFF2E2E38);

  // Subtle Borders (instead of heavy shadows)
  static const Color border = Color(0xFF2B2B36);
  static const Color borderLight = Color(0xFF383847);
  static const Color borderSubtle = Color(0xFF22222B);

  // Midnight Bloom Pastels & Accents
  static const Color lavender = Color(0xFFBCA5FF);       // Identity color
  static const Color lavenderMuted = Color(0xFF8B76CC);
  static const Color lavenderGlow = Color(0x33BCA5FF);

  static const Color peach = Color(0xFFFFBFAF);          // Attention / Ideas / Warmth
  static const Color peachMuted = Color(0xFFD68A78);
  static const Color peachGlow = Color(0x33FFBFAF);

  static const Color mint = Color(0xFFA9E5CF);           // Momentum / Success / Verified
  static const Color mintMuted = Color(0xFF6BB59C);
  static const Color mintGlow = Color(0x33A9E5CF);

  static const Color butter = Color(0xFFFFE599);         // Sparkles / Highlights
  static const Color sky = Color(0xFFB4DCFF);            // Collaboration / Cloud

  // Warm White Typography
  static const Color textPrimary = Color(0xFFF5F3FA);    // Warm crisp white
  static const Color textSecondary = Color(0xFFA09BB5);  // Editorial soft lavender-gray
  static const Color textMuted = Color(0xFF6C6782);      // Subtle captions, inactive icons
  static const Color textFaint = Color(0xFF454157);

  // Status & Logic
  static const Color success = mint;
  static const Color warning = butter;
  static const Color error = Color(0xFFFF6E6E);
  static const Color info = sky;

  // Aliases for seamless Midnight Bloom dark mode rendering across all components
  static const Color purple = lavender;
  static const Color purpleDark = lavenderMuted;
  static const Color purpleLight = Color(0xFFD6C8FF);
  static const Color softPeach = peach;
  static const Color cream = background;
  static const Color surfaceWhite = surface;
  static const Color surfaceWarm = elevated;
  static const Color lavenderSoft = elevated;
  static const Color lavenderGhost = Color(0xFF232130);
  static const Color mintLight = Color(0xFF1D2E28);
  static const Color butterLight = Color(0xFF2E2A1E);
  static const Color skyLight = Color(0xFF1D2733);

  // Selective Luminous Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF231F33), Color(0xFF111114)],
  );

  static const LinearGradient bloomHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF231F33),
      Color(0xFF1B1B21),
      Color(0xFF1F1C25),
    ],
  );

  static const LinearGradient lavenderGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFBCA5FF),
      Color(0xFF9074E8),
    ],
  );

  static const LinearGradient peachGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFBFAF),
      Color(0xFFFF9E8A),
    ],
  );

  static const LinearGradient mintGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA9E5CF),
      Color(0xFF7BD6B7),
    ],
  );
}
