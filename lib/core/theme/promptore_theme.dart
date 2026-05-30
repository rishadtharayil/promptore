import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'color_extension.dart';
import 'typography.dart';
import 'dimensions.dart';

/// PROMPTORE Theme
/// Assembles the complete dark, atmospheric theme.
class PromptoreTheme {
  PromptoreTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PromptoreColors.backgroundDark,
      extensions: [
        PromptoreColorExtension.dark(),
      ],
      colorScheme: const ColorScheme.dark(
        primary: PromptoreColors.mutedGoldDark,
        onPrimary: PromptoreColors.backgroundDark,
        secondary: PromptoreColors.fadedBronzeDark,
        onSecondary: PromptoreColors.parchmentDark,
        surface: PromptoreColors.surfaceDark,
        onSurface: PromptoreColors.parchmentDark,
        error: PromptoreColors.ember,
        onError: PromptoreColors.parchmentDark,
      ),

      // --- AppBar ---
      appBarTheme: AppBarTheme(
        backgroundColor: PromptoreColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.parchmentDark),
        iconTheme: const IconThemeData(
          color: PromptoreColors.dustySepiaDark,
          size: Dimensions.iconLg,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: PromptoreColors.backgroundDark,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: PromptoreColors.surfaceDark,
        elevation: Dimensions.cardElevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PromptoreColors.surfaceDark,
        selectedItemColor: PromptoreColors.mutedGoldDark,
        unselectedItemColor: PromptoreColors.charcoalDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // --- Bottom Sheet ---
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: PromptoreColors.surfaceElevatedDark,
        modalBackgroundColor: PromptoreColors.surfaceElevatedDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.sheetRadius),
          ),
        ),
      ),

      // --- Divider ---
      dividerTheme: const DividerThemeData(
        color: PromptoreColors.warmGrayDark,
        thickness: Dimensions.dividerThickness,
        space: 0,
      ),

      // --- Icon ---
      iconTheme: const IconThemeData(
        color: PromptoreColors.dustySepiaDark,
        size: Dimensions.iconMd,
      ),

      // --- Text Selection ---
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PromptoreColors.mutedGoldDark,
        selectionColor: PromptoreColors.mutedGoldDark.withValues(alpha: 0.3),
        selectionHandleColor: PromptoreColors.mutedGoldDark,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PromptoreColors.surfaceDark,
        hintStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.charcoalDark,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(
            color: PromptoreColors.warmGrayDark,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(
            color: PromptoreColors.mutedGoldDark,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.md,
        ),
      ),

      // --- Chip ---
      chipTheme: ChipThemeData(
        backgroundColor: PromptoreColors.surfaceDark,
        selectedColor: PromptoreColors.mutedGoldDark.withValues(alpha: 0.15),
        labelStyle: PromptoreTypography.metaMedium.copyWith(color: PromptoreColors.textTertiaryDark),
        side: const BorderSide(
          color: PromptoreColors.warmGrayDark,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.sm,
          vertical: Dimensions.xs,
        ),
      ),

      // --- Snackbar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PromptoreColors.surfaceElevatedDark,
        contentTextStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.parchmentDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),

      // --- Text Theme ---
      textTheme: TextTheme(
        displayLarge: PromptoreTypography.displayLarge.copyWith(color: PromptoreColors.parchmentDark),
        displayMedium: PromptoreTypography.displayMedium.copyWith(color: PromptoreColors.parchmentDark),
        displaySmall: PromptoreTypography.displaySmall.copyWith(color: PromptoreColors.parchmentDark),
        headlineLarge: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.parchmentDark),
        headlineMedium: PromptoreTypography.titleMedium.copyWith(color: PromptoreColors.parchmentDark),
        headlineSmall: PromptoreTypography.titleSmall.copyWith(color: PromptoreColors.dustySepiaDark),
        titleLarge: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.parchmentDark),
        titleMedium: PromptoreTypography.titleMedium.copyWith(color: PromptoreColors.parchmentDark),
        titleSmall: PromptoreTypography.titleSmall.copyWith(color: PromptoreColors.dustySepiaDark),
        bodyLarge: PromptoreTypography.bodyLarge.copyWith(color: PromptoreColors.parchmentDark),
        bodyMedium: PromptoreTypography.bodyMedium.copyWith(color: PromptoreColors.dustySepiaDark),
        bodySmall: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.dustySepiaDark),
        labelLarge: PromptoreTypography.labelLarge.copyWith(color: PromptoreColors.parchmentDark),
        labelMedium: PromptoreTypography.labelMedium.copyWith(color: PromptoreColors.dustySepiaDark),
        labelSmall: PromptoreTypography.labelSmall.copyWith(color: PromptoreColors.textTertiaryDark),
      ),

      // --- Page Transitions ---
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PromptoreColors.backgroundLight,
      extensions: [
        PromptoreColorExtension.light(),
      ],
      colorScheme: const ColorScheme.light(
        primary: PromptoreColors.mutedGoldLight,
        onPrimary: PromptoreColors.backgroundLight,
        secondary: PromptoreColors.fadedBronzeLight,
        onSecondary: PromptoreColors.inkDark,
        surface: PromptoreColors.surfaceLight,
        onSurface: PromptoreColors.inkDark,
        error: PromptoreColors.ember,
        onError: PromptoreColors.backgroundLight,
      ),

      // --- AppBar ---
      appBarTheme: AppBarTheme(
        backgroundColor: PromptoreColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.inkDark),
        iconTheme: const IconThemeData(
          color: PromptoreColors.dustySepiaLight,
          size: Dimensions.iconLg,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: PromptoreColors.backgroundLight,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: PromptoreColors.surfaceLight,
        elevation: Dimensions.cardElevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PromptoreColors.surfaceLight,
        selectedItemColor: PromptoreColors.mutedGoldLight,
        unselectedItemColor: PromptoreColors.charcoalLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // --- Bottom Sheet ---
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: PromptoreColors.surfaceElevatedLight,
        modalBackgroundColor: PromptoreColors.surfaceElevatedLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.sheetRadius),
          ),
        ),
      ),

      // --- Divider ---
      dividerTheme: const DividerThemeData(
        color: PromptoreColors.warmGrayLight,
        thickness: Dimensions.dividerThickness,
        space: 0,
      ),

      // --- Icon ---
      iconTheme: const IconThemeData(
        color: PromptoreColors.dustySepiaLight,
        size: Dimensions.iconMd,
      ),

      // --- Text Selection ---
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PromptoreColors.mutedGoldLight,
        selectionColor: PromptoreColors.mutedGoldLight.withValues(alpha: 0.3),
        selectionHandleColor: PromptoreColors.mutedGoldLight,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PromptoreColors.surfaceLight,
        hintStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.charcoalLight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(
            color: PromptoreColors.warmGrayLight,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(
            color: PromptoreColors.mutedGoldLight,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.md,
        ),
      ),

      // --- Chip ---
      chipTheme: ChipThemeData(
        backgroundColor: PromptoreColors.surfaceLight,
        selectedColor: PromptoreColors.mutedGoldLight.withValues(alpha: 0.15),
        labelStyle: PromptoreTypography.metaMedium.copyWith(color: PromptoreColors.textTertiaryLight),
        side: const BorderSide(
          color: PromptoreColors.warmGrayLight,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.sm,
          vertical: Dimensions.xs,
        ),
      ),

      // --- Snackbar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PromptoreColors.surfaceElevatedLight,
        contentTextStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.inkDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),

      // --- Text Theme ---
      textTheme: TextTheme(
        displayLarge: PromptoreTypography.displayLarge.copyWith(color: PromptoreColors.inkDark),
        displayMedium: PromptoreTypography.displayMedium.copyWith(color: PromptoreColors.inkDark),
        displaySmall: PromptoreTypography.displaySmall.copyWith(color: PromptoreColors.inkDark),
        headlineLarge: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.inkDark),
        headlineMedium: PromptoreTypography.titleMedium.copyWith(color: PromptoreColors.inkDark),
        headlineSmall: PromptoreTypography.titleSmall.copyWith(color: PromptoreColors.dustySepiaLight),
        titleLarge: PromptoreTypography.titleLarge.copyWith(color: PromptoreColors.inkDark),
        titleMedium: PromptoreTypography.titleMedium.copyWith(color: PromptoreColors.inkDark),
        titleSmall: PromptoreTypography.titleSmall.copyWith(color: PromptoreColors.dustySepiaLight),
        bodyLarge: PromptoreTypography.bodyLarge.copyWith(color: PromptoreColors.inkDark),
        bodyMedium: PromptoreTypography.bodyMedium.copyWith(color: PromptoreColors.dustySepiaLight),
        bodySmall: PromptoreTypography.bodySmall.copyWith(color: PromptoreColors.dustySepiaLight),
        labelLarge: PromptoreTypography.labelLarge.copyWith(color: PromptoreColors.inkDark),
        labelMedium: PromptoreTypography.labelMedium.copyWith(color: PromptoreColors.dustySepiaLight),
        labelSmall: PromptoreTypography.labelSmall.copyWith(color: PromptoreColors.textTertiaryLight),
      ),

      // --- Page Transitions ---
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
