import 'package:flutter/material.dart';

/// PROMPTORE Color Palette
/// A warm, dark, atmospheric palette inspired by
/// dark academia, cinematic noir, and vintage manuscripts.
class PromptoreColors {
  PromptoreColors._();

  // --- Core Backgrounds (Dark) ---
  /// Near-black with warm undertone — primary background
  static const background = Color(0xFF0D0B0E);

  /// Card and surface dark
  static const surface = Color(0xFF161418);

  /// Elevated surfaces (modals, sheets, raised cards)
  static const surfaceElevated = Color(0xFF1E1B21);

  // --- Core Backgrounds (Light - Vintage Parchment) ---
  /// Warm, vintage parchment paper background
  static const backgroundLight = Color(0xFFF7F2E8);

  /// Surface page background
  static const surfaceLight = Color(0xFFEDE5D6);

  /// Elevated surfaces
  static const surfaceElevatedLight = Color(0xFFE4DACB);

  // --- Neutrals (Dark) ---
  /// Borders, dividers, subtle lines
  static const warmGray = Color(0xFF2A2630);

  /// Tertiary elements, inactive states
  static const charcoal = Color(0xFF3A3540);

  // --- Neutrals (Light) ---
  /// Borders, dividers, subtle lines
  static const warmGrayLight = Color(0xFFDCD2C0);

  /// Tertiary elements, inactive states
  static const charcoalLight = Color(0xFFBCAFA0);

  // --- Accents ---
  /// Primary accent — aged gold, the signature PROMPTORE color
  static const mutedGold = Color(0xFFB8975A);

  /// Secondary accent — faded bronze
  static const fadedBronze = Color(0xFF8B7355);

  /// Light mode gold (slightly darker for parchment readability)
  static const mutedGoldLight = Color(0xFF9E7A3F);

  /// Light mode bronze
  static const fadedBronzeLight = Color(0xFF7A6142);

  /// Category accent — deep navy
  static const deepNavy = Color(0xFF1A1F3A);

  /// Alert, destructive actions — warm ember
  static const ember = Color(0xFF9E4B3C);

  // --- Text (Dark) ---
  /// Primary text — warm parchment
  static const parchment = Color(0xFFE8DFD0);

  /// Secondary text — dusty sepia
  static const dustySepia = Color(0xFFA69882);

  /// Tertiary text — muted, faded
  static const textTertiary = Color(0xFF6B6372);

  // --- Text (Light - Ink) ---
  /// Primary text — Dark fountain pen ink brown
  static const inkDark = Color(0xFF2C241D);

  /// Secondary text — Dusty sepia light
  static const dustySepiaLight = Color(0xFF6B5D4E);

  /// Tertiary text — muted sepia
  static const textTertiaryLight = Color(0xFF8B7E70);

  // --- Effects ---
  /// Ambient glow (low opacity gold)
  static const softGlow = Color(0x15B8975A);

  /// Vignette overlay
  static const vignette = Color(0x40000000);

  /// Grain overlay tint
  static const grain = Color(0x08E8DFD0);

  // --- Category Accent Colors ---
  static const categoryCharacter = Color(0xFF8B6F5A);
  static const categoryImage = Color(0xFF5A7B8B);
  static const categoryCoding = Color(0xFF6B8B5A);
  static const categoryPhilosophy = Color(0xFF7B5A8B);
  static const categoryStorytelling = Color(0xFF8B5A6B);
  static const categorySimulation = Color(0xFF5A8B7B);
  static const categoryProductivity = Color(0xFF8B8B5A);
  static const categoryExperimental = Color(0xFF8B5A5A);
  static const categoryWorldbuilding = Color(0xFF5A6B8B);
  static const categoryEmotional = Color(0xFF7B6B8B);
  static const categoryStrangeInternet = Color(0xFF5A8B6B);
  static const categoryPsychological = Color(0xFF6B5A8B);
  static const categoryOther = Color(0xFF6B6B6B);
}
