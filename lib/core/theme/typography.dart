import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PROMPTORE Typography System
/// Elegant serif for titles, readable sans-serif for body,
/// monospace for metadata — creating a manuscript-like reading experience.
///
/// Colors are NOT included in these styles. Color is applied by:
///   1. The textTheme in ThemeData (which sets default colors), or
///   2. Widgets via .copyWith(color: ...) using PromptoreColorExtension.
class PromptoreTypography {
  PromptoreTypography._();

  // ---------------------------------------------------------------------------
  // DISPLAY — Cormorant Garamond (elegant serif)
  // ---------------------------------------------------------------------------

  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle get displaySmall => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // TITLE — Cormorant Garamond
  // ---------------------------------------------------------------------------

  static TextStyle get titleLarge => GoogleFonts.cormorantGaramond(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get titleMedium => GoogleFonts.cormorantGaramond(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static TextStyle get titleSmall => GoogleFonts.cormorantGaramond(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // BODY — Inter (clean sans-serif)
  // ---------------------------------------------------------------------------

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.65,
    letterSpacing: 0.1,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // LABEL — Inter (medium weight for UI labels)
  // ---------------------------------------------------------------------------

  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.3,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // METADATA — JetBrains Mono (monospace)
  // ---------------------------------------------------------------------------

  static TextStyle get metaLarge => GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle get metaMedium => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.3,
  );

  static TextStyle get metaSmall => GoogleFonts.jetBrainsMono(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // ACCENT — Playfair Display (italic, for special emphasis)
  // ---------------------------------------------------------------------------

  static TextStyle get accent => GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.6,
  );

  static TextStyle get accentLarge => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // READING — Optimized for the Prompt Reader immersive view
  // ---------------------------------------------------------------------------

  static TextStyle get readerTitle => GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle get readerBody => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w300,
    height: 1.8,
    letterSpacing: 0.15,
  );

  static TextStyle get readerMeta => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.5,
  );
}
