import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Using FlexScheme.deepBlue as a base for a professional, trustworthy look.
  // Alternatively, we could use FlexScheme.brandBlue or similar.
  // DeepBlue corresponds to the "Sapphire Blue" idea we had.
  
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.deepBlue,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        // useTextTheme: true, // Deprecated
        useM2StyleDividerInM3: true,
        defaultRadius: 8.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        inputDecoratorUnfocusedHasBorder: true,
        fabUseShape: true,
        fabRadius: 12.0,
        chipRadius: 8.0,
        cardRadius: 8.0,
        dialogRadius: 8.0,
        timePickerElementRadius: 8.0,
        snackBarRadius: 8.0,
      ),
      visualDensity: VisualDensity.standard,
      // To ensure shadcn_ui compatibility or nice look, we might want to check fonts.
      // But we stick to default for now as we didn't add google_fonts.
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.deepBlue,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        // useTextTheme: true, // Deprecated
        useM2StyleDividerInM3: true,
        defaultRadius: 8.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        fabUseShape: true,
        fabRadius: 12.0,
        chipRadius: 8.0,
        cardRadius: 8.0,
        dialogRadius: 8.0,
        timePickerElementRadius: 8.0,
        snackBarRadius: 8.0,
      ),
      visualDensity: VisualDensity.standard,
    );
  }
}
