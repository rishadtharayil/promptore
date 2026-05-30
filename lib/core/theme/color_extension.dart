import 'package:flutter/material.dart';
import 'colors.dart';

/// Theme extension that carries all PROMPTORE color tokens inside ThemeData.
///
/// Widgets resolve colors via `PromptoreColorExtension.of(context)` which
/// always returns the correct set (dark or light) for the active theme.
class PromptoreColorExtension extends ThemeExtension<PromptoreColorExtension> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color warmGray;
  final Color charcoal;
  final Color mutedGold;
  final Color fadedBronze;
  final Color parchment;
  final Color dustySepia;
  final Color textTertiary;
  final Color softGlow;
  final Color grain;

  const PromptoreColorExtension({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.warmGray,
    required this.charcoal,
    required this.mutedGold,
    required this.fadedBronze,
    required this.parchment,
    required this.dustySepia,
    required this.textTertiary,
    required this.softGlow,
    required this.grain,
  });

  /// Dark theme color set.
  factory PromptoreColorExtension.dark() {
    return const PromptoreColorExtension(
      background: PromptoreColors.backgroundDark,
      surface: PromptoreColors.surfaceDark,
      surfaceElevated: PromptoreColors.surfaceElevatedDark,
      warmGray: PromptoreColors.warmGrayDark,
      charcoal: PromptoreColors.charcoalDark,
      mutedGold: PromptoreColors.mutedGoldDark,
      fadedBronze: PromptoreColors.fadedBronzeDark,
      parchment: PromptoreColors.parchmentDark,
      dustySepia: PromptoreColors.dustySepiaDark,
      textTertiary: PromptoreColors.textTertiaryDark,
      softGlow: PromptoreColors.softGlowDark,
      grain: PromptoreColors.grainDark,
    );
  }

  /// Light theme color set.
  factory PromptoreColorExtension.light() {
    return const PromptoreColorExtension(
      background: PromptoreColors.backgroundLight,
      surface: PromptoreColors.surfaceLight,
      surfaceElevated: PromptoreColors.surfaceElevatedLight,
      warmGray: PromptoreColors.warmGrayLight,
      charcoal: PromptoreColors.charcoalLight,
      mutedGold: PromptoreColors.mutedGoldLight,
      fadedBronze: PromptoreColors.fadedBronzeLight,
      parchment: PromptoreColors.inkDark,
      dustySepia: PromptoreColors.dustySepiaLight,
      textTertiary: PromptoreColors.textTertiaryLight,
      softGlow: PromptoreColors.softGlowLight,
      grain: PromptoreColors.grainLight,
    );
  }

  /// Convenience accessor from any widget's build context.
  static PromptoreColorExtension of(BuildContext context) {
    return Theme.of(context).extension<PromptoreColorExtension>()!;
  }

  @override
  PromptoreColorExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? warmGray,
    Color? charcoal,
    Color? mutedGold,
    Color? fadedBronze,
    Color? parchment,
    Color? dustySepia,
    Color? textTertiary,
    Color? softGlow,
    Color? grain,
  }) {
    return PromptoreColorExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      warmGray: warmGray ?? this.warmGray,
      charcoal: charcoal ?? this.charcoal,
      mutedGold: mutedGold ?? this.mutedGold,
      fadedBronze: fadedBronze ?? this.fadedBronze,
      parchment: parchment ?? this.parchment,
      dustySepia: dustySepia ?? this.dustySepia,
      textTertiary: textTertiary ?? this.textTertiary,
      softGlow: softGlow ?? this.softGlow,
      grain: grain ?? this.grain,
    );
  }

  @override
  PromptoreColorExtension lerp(
    covariant PromptoreColorExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return PromptoreColorExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      warmGray: Color.lerp(warmGray, other.warmGray, t)!,
      charcoal: Color.lerp(charcoal, other.charcoal, t)!,
      mutedGold: Color.lerp(mutedGold, other.mutedGold, t)!,
      fadedBronze: Color.lerp(fadedBronze, other.fadedBronze, t)!,
      parchment: Color.lerp(parchment, other.parchment, t)!,
      dustySepia: Color.lerp(dustySepia, other.dustySepia, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      softGlow: Color.lerp(softGlow, other.softGlow, t)!,
      grain: Color.lerp(grain, other.grain, t)!,
    );
  }
}
