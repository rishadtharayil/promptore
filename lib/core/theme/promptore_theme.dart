import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';
import 'dimensions.dart';

/// PROMPTORE Theme
/// Assembles the complete dark, atmospheric theme.
class PromptoreTheme {
  PromptoreTheme._();

  static bool isLight = false;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PromptoreColors.background,
      colorScheme: ColorScheme.dark(
        primary: PromptoreColors.mutedGold,
        onPrimary: PromptoreColors.background,
        secondary: PromptoreColors.fadedBronze,
        onSecondary: PromptoreColors.parchment,
        surface: PromptoreColors.surface,
        onSurface: PromptoreColors.parchment,
        error: PromptoreColors.ember,
        onError: PromptoreColors.parchment,
      ),

      // --- AppBar ---
      appBarTheme: AppBarTheme(
        backgroundColor: PromptoreColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: PromptoreTypography.titleLarge,
        iconTheme: IconThemeData(
          color: PromptoreColors.dustySepia,
          size: Dimensions.iconLg,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: PromptoreColors.background,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: PromptoreColors.surface,
        elevation: Dimensions.cardElevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PromptoreColors.surface,
        selectedItemColor: PromptoreColors.mutedGold,
        unselectedItemColor: PromptoreColors.charcoal,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // --- Bottom Sheet ---
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: PromptoreColors.surfaceElevated,
        modalBackgroundColor: PromptoreColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.sheetRadius),
          ),
        ),
      ),

      // --- Divider ---
      dividerTheme: DividerThemeData(
        color: PromptoreColors.warmGray,
        thickness: Dimensions.dividerThickness,
        space: 0,
      ),

      // --- Icon ---
      iconTheme: IconThemeData(
        color: PromptoreColors.dustySepia,
        size: Dimensions.iconMd,
      ),

      // --- Text Selection ---
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PromptoreColors.mutedGold,
        selectionColor: PromptoreColors.mutedGold.withValues(alpha: 0.3),
        selectionHandleColor: PromptoreColors.mutedGold,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PromptoreColors.surface,
        hintStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.charcoal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide(
            color: PromptoreColors.warmGray,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide(
            color: PromptoreColors.mutedGold,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.md,
        ),
      ),

      // --- Chip ---
      chipTheme: ChipThemeData(
        backgroundColor: PromptoreColors.surface,
        selectedColor: PromptoreColors.mutedGold.withValues(alpha: 0.15),
        labelStyle: PromptoreTypography.metaMedium,
        side: BorderSide(
          color: PromptoreColors.warmGray,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.sm,
          vertical: Dimensions.xs,
        ),
      ),

      // --- Snackbar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PromptoreColors.surfaceElevated,
        contentTextStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.parchment,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),

      // --- Text Theme ---
      textTheme: TextTheme(
        displayLarge: PromptoreTypography.displayLarge,
        displayMedium: PromptoreTypography.displayMedium,
        displaySmall: PromptoreTypography.displaySmall,
        headlineLarge: PromptoreTypography.titleLarge,
        headlineMedium: PromptoreTypography.titleMedium,
        headlineSmall: PromptoreTypography.titleSmall,
        titleLarge: PromptoreTypography.titleLarge,
        titleMedium: PromptoreTypography.titleMedium,
        titleSmall: PromptoreTypography.titleSmall,
        bodyLarge: PromptoreTypography.bodyLarge,
        bodyMedium: PromptoreTypography.bodyMedium,
        bodySmall: PromptoreTypography.bodySmall,
        labelLarge: PromptoreTypography.labelLarge,
        labelMedium: PromptoreTypography.labelMedium,
        labelSmall: PromptoreTypography.labelSmall,
      ),

      // --- Page Transitions ---
      pageTransitionsTheme: PageTransitionsTheme(
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
      scaffoldBackgroundColor: PromptoreColors.background,
      colorScheme: ColorScheme.light(
        primary: PromptoreColors.mutedGold,
        onPrimary: PromptoreColors.background,
        secondary: PromptoreColors.fadedBronze,
        onSecondary: PromptoreColors.parchment,
        surface: PromptoreColors.surface,
        onSurface: PromptoreColors.parchment,
        error: PromptoreColors.ember,
        onError: PromptoreColors.parchment,
      ),

      // --- AppBar ---
      appBarTheme: AppBarTheme(
        backgroundColor: PromptoreColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: PromptoreTypography.titleLarge,
        iconTheme: IconThemeData(
          color: PromptoreColors.dustySepia,
          size: Dimensions.iconLg,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: PromptoreColors.background,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: PromptoreColors.surface,
        elevation: Dimensions.cardElevation,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PromptoreColors.surface,
        selectedItemColor: PromptoreColors.mutedGold,
        unselectedItemColor: PromptoreColors.charcoal,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // --- Bottom Sheet ---
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: PromptoreColors.surfaceElevated,
        modalBackgroundColor: PromptoreColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.sheetRadius),
          ),
        ),
      ),

      // --- Divider ---
      dividerTheme: DividerThemeData(
        color: PromptoreColors.warmGray,
        thickness: Dimensions.dividerThickness,
        space: 0,
      ),

      // --- Icon ---
      iconTheme: IconThemeData(
        color: PromptoreColors.dustySepia,
        size: Dimensions.iconMd,
      ),

      // --- Text Selection ---
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PromptoreColors.mutedGold,
        selectionColor: PromptoreColors.mutedGold.withValues(alpha: 0.3),
        selectionHandleColor: PromptoreColors.mutedGold,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PromptoreColors.surface,
        hintStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.charcoal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide(
            color: PromptoreColors.warmGray,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: BorderSide(
            color: PromptoreColors.mutedGold,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.md,
        ),
      ),

      // --- Chip ---
      chipTheme: ChipThemeData(
        backgroundColor: PromptoreColors.surface,
        selectedColor: PromptoreColors.mutedGold.withValues(alpha: 0.15),
        labelStyle: PromptoreTypography.metaMedium,
        side: BorderSide(
          color: PromptoreColors.warmGray,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.sm,
          vertical: Dimensions.xs,
        ),
      ),

      // --- Snackbar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PromptoreColors.surfaceElevated,
        contentTextStyle: PromptoreTypography.bodyMedium.copyWith(
          color: PromptoreColors.parchment,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),

      // --- Text Theme ---
      textTheme: TextTheme(
        displayLarge: PromptoreTypography.displayLarge,
        displayMedium: PromptoreTypography.displayMedium,
        displaySmall: PromptoreTypography.displaySmall,
        headlineLarge: PromptoreTypography.titleLarge,
        headlineMedium: PromptoreTypography.titleMedium,
        headlineSmall: PromptoreTypography.titleSmall,
        titleLarge: PromptoreTypography.titleLarge,
        titleMedium: PromptoreTypography.titleMedium,
        titleSmall: PromptoreTypography.titleSmall,
        bodyLarge: PromptoreTypography.bodyLarge,
        bodyMedium: PromptoreTypography.bodyMedium,
        bodySmall: PromptoreTypography.bodySmall,
        labelLarge: PromptoreTypography.labelLarge,
        labelMedium: PromptoreTypography.labelMedium,
        labelSmall: PromptoreTypography.labelSmall,
      ),

      // --- Page Transitions ---
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
