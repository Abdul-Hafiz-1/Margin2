import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class MarginTypography {
  // Primary Headings (Quicksand) — Editorial & Approachable
  static TextStyle displayLarge = GoogleFonts.quicksand(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: MarginColors.textPrimary,
    letterSpacing: -0.6,
  );

  static TextStyle displayMedium = GoogleFonts.quicksand(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: MarginColors.textPrimary,
    letterSpacing: -0.4,
  );

  static TextStyle headingLarge = GoogleFonts.quicksand(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: MarginColors.textPrimary,
  );

  static TextStyle headingMedium = GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: MarginColors.textPrimary,
  );

  static TextStyle headingSmall = GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: MarginColors.textPrimary,
  );

  // Friendly Labels & Navigation (Quicksand)
  static TextStyle navLabel = GoogleFonts.quicksand(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle button = GoogleFonts.quicksand(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle chip = GoogleFonts.quicksand(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // Secondary Body & Dense Content (Inter)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: MarginColors.textPrimary,
    height: 1.55,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: MarginColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodyMediumBold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: MarginColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: MarginColors.textSecondary,
    height: 1.4,
  );

  // Metadata & Captions (Inter)
  static TextStyle metadata = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: MarginColors.textMuted,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: MarginColors.textMuted,
  );
}
