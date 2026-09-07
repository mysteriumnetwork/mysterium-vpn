import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/views/subscription/widgets/cancel_subscription_action_footer.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../../support/test_localizations.dart';

void main() {
  Future<void> pumpActionFooter({
    required WidgetTester tester,
    bool primaryButtonEnabled = false,
    bool processing = false,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryButtonPressed,
    VoidCallback? onPrimaryButtonPressed,
    double bottomViewPadding = 0,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(viewPadding: EdgeInsets.only(bottom: bottomViewPadding)),
          child: child!,
        ),
        home: CancelSubscriptionActionFooter(
          primaryButtonLabel: 'Pause',
          secondaryButtonLabel: secondaryButtonLabel,
          isProcessing: processing,
          primaryButtonEnabled: primaryButtonEnabled,
          onPrimaryButtonPressed: onPrimaryButtonPressed ?? () {},
          onSecondaryButtonPressed: onSecondaryButtonPressed,
        ),
      ),
    );
  }

  testWidgets('disables the primary button when primaryButtonEnabled is false', (tester) async {
    // arrange
    var pressed = false;
    await pumpActionFooter(
      tester: tester,
      onPrimaryButtonPressed: () {
        pressed = true;
      },
    );

    // act
    await tester.tap(find.byType(ButtonPrimary), warnIfMissed: false);

    // assert
    expect(pressed, isFalse);
  });

  testWidgets('enables the primary button when primaryButtonEnabled is true', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester, primaryButtonEnabled: true);

    // act
    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));

    // assert
    expect(button.onPressed, isNotNull);
  });

  testWidgets('calls onPrimaryButtonPressed when the primary button is pressed', (tester) async {
    // arrange
    var pressed = false;
    await pumpActionFooter(
      tester: tester,
      primaryButtonEnabled: true,
      onPrimaryButtonPressed: () {
        pressed = true;
      },
    );

    // act
    await tester.tap(find.byType(ButtonPrimary));

    // assert
    expect(pressed, isTrue);
  });

  testWidgets('processing state is shown when processing is true', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester, processing: true);

    // act
    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));

    // assert
    expect(button.loading, isA<ButtonLoading>());
  });

  testWidgets('secondary button is shown when secondaryButtonLabel is not null', (tester) async {
    // arrange
    await pumpActionFooter(
      tester: tester,
      secondaryButtonLabel: 'Secondary',
      onSecondaryButtonPressed: () {},
    );

    // act
    final button = tester.widget<ButtonTertiary>(find.byType(ButtonTertiary));

    // assert
    expect(button, isNotNull);
    expect(button, isA<ButtonTertiary>());
  });

  testWidgets('secondary button is not shown when secondaryButtonLabel is null', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester);

    // act

    // assert
    expect(find.byType(ButtonTertiary), findsNothing);
  });

  testWidgets('secondary button is called when onSecondaryButtonPressed is called', (tester) async {
    // arrange
    var pressed = false;
    await pumpActionFooter(
      tester: tester,
      secondaryButtonLabel: 'Secondary',
      onSecondaryButtonPressed: () {
        pressed = true;
      },
    );

    // act
    await tester.tap(find.byType(ButtonTertiary));

    // assert
    expect(pressed, isTrue);
  });

  testWidgets('disables the secondary button when processing is true', (tester) async {
    // arrange
    await pumpActionFooter(
      tester: tester,
      processing: true,
      secondaryButtonLabel: 'Secondary',
      onSecondaryButtonPressed: () {},
    );

    // act
    final button = tester.widget<ButtonTertiary>(find.byType(ButtonTertiary));

    // assert
    expect(button.onPressed, isNull);
    expect(button, isA<ButtonTertiary>());
  });

  testWidgets('keeps the design bottom padding when there is no system inset', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester);

    // act
    final padding = tester
        .widget<Padding>(
          find.ancestor(of: find.byType(ButtonPrimary), matching: find.byType(Padding)).last,
        )
        .padding
        .resolve(TextDirection.ltr);

    // assert
    expect(padding.bottom, 40);
  });

  testWidgets('pads past the system inset so buttons clear the nav bar', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester, bottomViewPadding: 48);

    // act
    final padding = tester
        .widget<Padding>(
          find.ancestor(of: find.byType(ButtonPrimary), matching: find.byType(Padding)).last,
        )
        .padding
        .resolve(TextDirection.ltr);

    // assert
    expect(padding.bottom, 48 + 16);
  });

  testWidgets('secondary button is not shown when only the label is set', (tester) async {
    // arrange
    await pumpActionFooter(tester: tester, secondaryButtonLabel: 'Secondary');

    // act

    // assert
    expect(find.byType(ButtonTertiary), findsNothing);
  });
}
