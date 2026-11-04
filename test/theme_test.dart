import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carecampus/main.dart';
import 'package:carecampus/utils/theme.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppTheme Theme Configuration Tests', () {
    testWidgets('Light and Dark theme properties are correctly configured', (tester) async {
      final light = AppTheme.lightTheme;
      expect(light.brightness, Brightness.light);
      expect(light.scaffoldBackgroundColor, AppTheme.skyWhite);
      expect(light.primaryColor, AppTheme.tealBlue);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(light.colorScheme.surface, AppTheme.white);
      expect(light.colorScheme.onSurface, AppTheme.navyText);

      final dark = AppTheme.darkTheme;
      expect(dark.brightness, Brightness.dark);
      expect(dark.scaffoldBackgroundColor, AppTheme.darkBg);
      expect(dark.primaryColor, AppTheme.tealBlue);
      expect(dark.colorScheme.brightness, Brightness.dark);
      expect(dark.colorScheme.surface, AppTheme.darkSurface);
      expect(dark.colorScheme.onSurface, AppTheme.darkTextHigh);
      await tester.pump();
    });

    testWidgets('Theme-aware helpers return correct colors based on context brightness',
        (tester) async {
      Color? lightScaffold;
      Color? lightCard;
      Color? lightTextPrimary;
      Color? lightTextSecondary;
      Color? lightBorder;

      Color? darkScaffold;
      Color? darkCard;
      Color? darkTextPrimary;
      Color? darkTextSecondary;
      Color? darkBorder;

      // Light mode test
      await tester.pumpWidget(
        Theme(
          data: AppTheme.lightTheme,
          child: Builder(builder: (context) {
            lightScaffold = AppTheme.scaffoldBg(context);
            lightCard = AppTheme.cardBg(context);
            lightTextPrimary = AppTheme.textPrimary(context);
            lightTextSecondary = AppTheme.textSecondary(context);
            lightBorder = AppTheme.borderColor(context);
            return const SizedBox();
          }),
        ),
      );

      expect(lightScaffold, AppTheme.skyWhite);
      expect(lightCard, AppTheme.white);
      expect(lightTextPrimary, AppTheme.navyText);
      expect(lightTextSecondary, AppTheme.slateText);
      expect(lightBorder, AppTheme.iceBlue);

      // Dark mode test
      await tester.pumpWidget(
        Theme(
          data: AppTheme.darkTheme,
          child: Builder(builder: (context) {
            darkScaffold = AppTheme.scaffoldBg(context);
            darkCard = AppTheme.cardBg(context);
            darkTextPrimary = AppTheme.textPrimary(context);
            darkTextSecondary = AppTheme.textSecondary(context);
            darkBorder = AppTheme.borderColor(context);
            return const SizedBox();
          }),
        ),
      );

      expect(darkScaffold, AppTheme.darkBg);
      expect(darkCard, AppTheme.darkSurface);
      expect(darkTextPrimary, AppTheme.darkTextHigh);
      expect(darkTextSecondary, AppTheme.darkTextMed);
      expect(darkBorder, AppTheme.darkBorder);
    });

    testWidgets('CareCampusApp has system themeMode and both light and dark themes',
        (tester) async {
      const app = CareCampusApp(home: SizedBox());
      await tester.pumpWidget(app);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, ThemeMode.system);
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.theme?.brightness, Brightness.light);
      expect(materialApp.darkTheme?.brightness, Brightness.dark);
    });
  });
}
