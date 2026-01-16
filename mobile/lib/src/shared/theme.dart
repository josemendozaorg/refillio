import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Palette
  static const Color primaryDark = Color(0xFF10B981); // Emerald
  static const Color secondaryDark = Color(0xFFF59E0B); // Gold
  static const Color backgroundDark = Color(0xFF0F1115); // Deep Charcoal
  static const Color surfaceDark = Color(0xFF1A1D23); // Slightly lighter charcoal

  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.deepBlue,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useM2StyleDividerInM3: true,
        defaultRadius: 16.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12.0,
        inputDecoratorUnfocusedHasBorder: true,
        fabUseShape: true,
        fabRadius: 16.0,
        chipRadius: 12.0,
        cardRadius: 16.0,
        dialogRadius: 16.0,
      ),
      visualDensity: VisualDensity.standard,
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: primaryDark,
        primaryContainer: Color(0xFF064E3B),
        secondary: secondaryDark,
        secondaryContainer: Color(0xFF78350F),
        tertiary: Color(0xFF3B82F6), // Soft Blue
        tertiaryContainer: Color(0xFF1E3A8A),
        appBarColor: backgroundDark,
        error: Color(0xFFEF4444),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useM2StyleDividerInM3: true,
        defaultRadius: 16.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12.0,
        fabUseShape: true,
        fabRadius: 16.0,
        chipRadius: 12.0,
        cardRadius: 16.0,
        dialogRadius: 16.0,
      ),
      visualDensity: VisualDensity.standard,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackground: backgroundDark,
    );
  }
}
