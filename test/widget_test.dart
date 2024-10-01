// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:students_app/main.dart';
import 'package:students_app/models/student.dart';
import 'package:students_app/services/api_service.dart';
import 'package:logging/logging.dart';

class MockApiService extends Mock implements ApiService {}

final _logger = Logger('StudentListScreenTest');

void main() {
  setUpAll(() {
    registerFallbackValue(Student(id: 0, firstName: '', lastName: '', course: '', year: '', enrolled: false));
  });

  testWidgets('Student List Screen displays students', (WidgetTester tester) async {
    final mockApiService = MockApiService();

    when(() => mockApiService.getStudents()).thenAnswer((_) async {
      _logger.info('Mocking getStudents...');
      return [
        Student(id: 1, firstName: 'Kobe', lastName: 'Roca', course: 'BSIT', year: '2024', enrolled: true),
        Student(id: 2, firstName: 'Melben', lastName: 'Canlas', course: 'BSHM', year: '2024', enrolled: false),
        Student(id: 3, firstName: 'Jasmine', lastName: 'Austria', course: 'BSHM', year: '2024', enrolled: false),
      ];
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StudentListScreen(apiService: mockApiService),
      ),
    ));

    await tester.pumpAndSettle();

    // Debug: Print widget tree
    debugPrint('$tester');

    // Check that the mocked student data is displayed
    expect(find.text('Kobe Roca'), findsOneWidget);
    expect(find.text('Melben Canlas'), findsOneWidget);
    expect(find.text('Jasmine Austria'), findsOneWidget);

    // Optional: Additional checks
  });
}












