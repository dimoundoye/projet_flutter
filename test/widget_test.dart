import 'package:flutter_test/flutter_test.dart';
import 'package:projet_flutter/main.dart';

void main() {
  testWidgets('App displays meal list on start', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Gaspillage Cantine'), findsOneWidget);
    expect(find.text('Thiéboudiène'), findsOneWidget);
    expect(find.text('Statistiques cumulées'), findsOneWidget);
  });

  testWidgets('Tapping a meal opens detail screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Thiéboudiène'));
    await tester.pumpAndSettle();

    expect(find.text('Portions préparées'), findsOneWidget);
    expect(find.text('Barre de gaspillage'), findsOneWidget);
  });

  testWidgets('FAB opens form screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Ajouter un repas'));
    await tester.pumpAndSettle();

    expect(find.text('Nouveau repas'), findsOneWidget);
    expect(find.text('Plat'), findsOneWidget);
  });
}
