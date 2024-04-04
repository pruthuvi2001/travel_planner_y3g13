import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:travel_planner_y3g13/pages/POI_page.dart';
import 'dart:convert';

import 'package:travel_planner_y3g13/pages/home_page.dart';

// Mock class for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('HomePage Widget Tests', () {
    late MockClient client;

    setUp(() {
      client = MockClient();
    });

    testWidgets('HomePage UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Travel Planner'), findsOneWidget);
      expect(find.text('Search for Places'), findsOneWidget);
      expect(find.byKey(const ValueKey('Starting Point')), findsOneWidget);
      expect(find.byKey(const ValueKey('Ending Point')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Search Places Button Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Mock API response for searching places
      when(client.get(Uri.parse('https://api.tomtom.com/search/2/geocode/Kandyjson?key=BG52qlOwM5RN8bpA3AVHatJ5gr7ZCwlA&countrySet=LK'))).
      thenAnswer((_) async => http.Response(jsonEncode({}), 200));

      // Tap the search places button
      await tester.tap(find.text('Search Places'));
      await tester.pump();

      // Expect the loading dialog to appear
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for a short duration for the search operation to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Expect the dialog to be dismissed after search completes
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Error Dialog Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Mock API response to throw an error
      when(client.get(Uri.parse('https://api.tomtom.com/search/2/geocode/Kandyjson?key=BG52qlOwM5RN8bpA3AVHatJ5gr7ZCwlA&countrySet=LK'))).
      thenThrow(Exception('Failed to fetch coordinates'));

      // Tap the search places button
      await tester.tap(find.text('Search Places'));
      await tester.pump();

      // Expect the error dialog to appear
      expect(find.text('Failed to fetch coordinates'), findsOneWidget);

      // Tap the close button in the error dialog
      await tester.tap(find.text('Close'));
      await tester.pump();

      // Expect the error dialog to be dismissed
      expect(find.text('Failed to fetch coordinates'), findsNothing);
    });

    testWidgets('Test Search Place Functionality', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      final startingField = find.byKey(const ValueKey('Starting Point'));
      final endingField = find.byKey(const ValueKey('Ending Point'));

      await tester.enterText(startingField, 'Valid Starting Point');
      await tester.enterText(endingField, 'Valid Ending Point');

      final searchButton = find.text('Search Places');
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      final loadingDialog = find.text('Searching for attractions...');
      expect(loadingDialog, findsOneWidget);
    });

    testWidgets('Test Navigation', (WidgetTester tester) async {
      // Build the HomePage widget
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Tap the search button to trigger navigation
      final searchButton = find.text('Search Places');
      await tester.tap(searchButton);
      await tester.pump();

      // Verify that navigation occurs correctly to the next page
      expect(find.byType(LocationList), findsOneWidget);
    });


    tearDown(() {
      client.close();
    });
  });
}
