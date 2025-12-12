import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsScreen', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('shows loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('displays all widgets after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('displays app bar with logo', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CommonAppBar), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays current font size text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Current size:'), findsOneWidget);
      expect(find.textContaining('px'), findsOneWidget);
    });

    testWidgets('displays font size slider with correct properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
      expect(slider.onChanged, isNotNull);
    });

    testWidgets('displays info message about font size changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
            'Font size changes are saved automatically. Restart the app to see changes in all screens.'),
        findsOneWidget,
      );
    });

    testWidgets('slider changes font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Find initial font size
      final Slider initialSlider = tester.widget<Slider>(find.byType(Slider));
      final double initialValue = initialSlider.value;

      // Drag slider to a new position
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Check that slider value changed
      final Slider updatedSlider = tester.widget<Slider>(find.byType(Slider));
      expect(updatedSlider.value, isNot(equals(initialValue)));
    });

    testWidgets('font size text updates when slider changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Drag slider to the right (increase font size)
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pumpAndSettle();

      // Verify the current size text exists and changed
      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                child: const Text('Go to Settings'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Go to Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);

      // Tap back button
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Should be back to original screen
      expect(find.text('Go to Settings'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('displays sample preview text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('This is sample text to preview the font size.'),
        findsOneWidget,
      );
    });

    testWidgets('sample text uses current font size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      final double fontSize = slider.value;

      // Find the sample text widget
      final Finder sampleTextFinder =
          find.text('This is sample text to preview the font size.');
      final Text sampleText = tester.widget<Text>(sampleTextFinder);

      expect(sampleText.style?.fontSize, equals(fontSize));
    });

    testWidgets('current size text uses current font size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      final double fontSize = slider.value;

      // Find the current size text
      final Finder currentSizeFinder = find.textContaining('Current size:');
      final Text currentSizeText = tester.widget<Text>(currentSizeFinder);

      expect(currentSizeText.style?.fontSize, equals(fontSize));
    });

    testWidgets('has proper layout structure with Padding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('displays SizedBox widgets for spacing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);

      final List<SizedBox> sizedBoxes =
          tester.widgetList<SizedBox>(find.byType(SizedBox)).toList();
      expect(sizedBoxes.length, greaterThan(0));
      expect(sizedBoxes.any((sb) => sb.height == 20), isTrue);
    });

    testWidgets('slider label shows current value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      final String expectedLabel = slider.value.toInt().toString();

      expect(slider.label, equals(expectedLabel));
    });

    testWidgets('Settings title uses heading1 style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final AppBar appBar = tester.widget<AppBar>(find.byType(AppBar));
      final Text titleText = appBar.title as Text;
      expect(titleText.style, equals(AppStyles.heading1));
    });

    testWidgets('Font Size label uses heading2 style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Text fontSizeText = tester.widget<Text>(find.text('Font Size'));
      expect(fontSizeText.style, equals(AppStyles.heading2));
    });

    testWidgets('info message uses normalText style and center alignment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Finder infoFinder = find.text(
        'Font size changes are saved automatically. Restart the app to see changes in all screens.',
      );
      final Text infoText = tester.widget<Text>(infoFinder);

      expect(infoText.style, equals(AppStyles.normalText));
      expect(infoText.textAlign, equals(TextAlign.center));
    });

    testWidgets('back button text uses normalText style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final ElevatedButton button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final Text buttonText = button.child as Text;
      expect(buttonText.style, equals(AppStyles.normalText));
    });

    testWidgets('loads initial font size from AppStyles',
        (WidgetTester tester) async {
      // Set a specific value in SharedPreferences
      SharedPreferences.setMockInitialValues({'fontSize': 18.0});
      await AppStyles.loadFontSize();

      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Current size: 18px'), findsOneWidget);
    });

    testWidgets('slider can be set to minimum value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Drag slider all the way to the left
      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(12.0));
    });

    testWidgets('slider can be set to maximum value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Drag slider all the way to the right
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(24.0));
    });

    testWidgets('loading state only shows CircularProgressIndicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      // Before pumpAndSettle, should be in loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Slider), findsNothing);
      expect(find.text('Font Size'), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('loading indicator is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );

      final Center centerWidget = tester.widget<Center>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Center),
        ),
      );
      expect(centerWidget, isNotNull);
    });

    testWidgets('Column children are in correct order',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Column column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Padding).last,
          matching: find.byType(Column),
        ),
      );

      expect(column.children.length, greaterThan(5));
    });

    testWidgets('Padding has correct horizontal and vertical padding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      final Padding bodyPadding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(Scaffold),
              matching: find.byType(Padding),
            )
            .last,
      );

      expect(bodyPadding.padding, equals(const EdgeInsets.all(16.0)));
    });
  });
}
