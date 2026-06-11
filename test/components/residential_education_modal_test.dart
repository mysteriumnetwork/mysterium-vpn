import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/residential_education_modal.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

ResidentialEducationModal _modal({VoidCallback? onGotIt}) => ResidentialEducationModal(
  title: 'How Residential IPs work',
  subtitle: 'Residential IPs are different from high-speed IPs.',
  block1Title: 'Real household devices',
  block1Body: 'Body one.',
  block2Title: 'Availability can change',
  block2Body: 'Body two.',
  block3Title: 'Automatic reconnection',
  block3Body: 'Body three.',
  gotItLabel: 'Got it',
  onGotIt: onGotIt ?? () {},
);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ScreenType screenType = ScreenType.mobile,
}) => tester.pumpWidget(
  MaterialApp(
    theme: DesignSystem.lightTheme,
    home: ScreenTypeOverride(
      screenType: screenType,
      child: Scaffold(body: child),
    ),
  ),
);

void main() {
  group('ResidentialEducationModal', () {
    testWidgets('renders title, subtitle, three blocks and Got it', (tester) async {
      await _pump(tester, _modal());
      expect(find.text('How Residential IPs work'), findsOneWidget);
      expect(find.text('Residential IPs are different from high-speed IPs.'), findsOneWidget);
      expect(find.text('Real household devices'), findsOneWidget);
      expect(find.text('Availability can change'), findsOneWidget);
      expect(find.text('Automatic reconnection'), findsOneWidget);
      expect(find.text('Got it'), findsOneWidget);
      expect(find.byType(DecoratedIcon), findsNWidgets(4)); // brand badge + 3 blocks
    });

    testWidgets('invokes onGotIt', (tester) async {
      var tapped = false;
      await _pump(tester, _modal(onGotIt: () => tapped = true));
      await tester.tap(find.text('Got it'));
      expect(tapped, isTrue);
    });

    testWidgets('shows close button on desktop only', (tester) async {
      await _pump(tester, _modal(), screenType: ScreenType.desktop);
      expect(find.byIcon(UntitledUI.x_close), findsOneWidget);

      await _pump(tester, _modal());
      expect(find.byIcon(UntitledUI.x_close), findsNothing);
    });
  });
}
