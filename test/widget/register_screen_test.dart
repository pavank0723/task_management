import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management/common/auth/auth.dart';
import 'package:task_management/res/app_string.dart';
import 'package:task_management/route/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management/ui/ui.dart';
import 'package:task_management/utils/utils.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  testWidgets('RegisterScreen widget test', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    final mockUser = MockUser();

    // Simulate successful registration
    when(mockAuthService.signUpWithEmail('test@example.com', 'password'))
        .thenAnswer((_) async => mockUser);

    // Build RegisterScreen widget with the mocked AuthService
    await tester.pumpWidget(
      MaterialApp(
        home: const RegisterScreen(),
        routes: {
          AppRoute.toDoScreen: (context) => const ToDoScreen(),
        },
      ),
    );

    // Enter text into the email and password fields
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap the register button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget after the state change

    // Verify that signUpWithEmail was called
    verify(mockAuthService.signUpWithEmail('test@example.com', 'password'))
        .called(1);

    // Simulate navigation to the ToDoScreen
    await tester.pumpAndSettle(); // Wait for all animations to complete
    expect(find.byType(ToDoScreen), findsOneWidget);
  });

  testWidgets('RegisterScreen shows SnackBar on failed registration',
      (WidgetTester tester) async {
    final mockAuthService = MockAuthService();

    // Simulate failed registration
    when(mockAuthService.signUpWithEmail('test@example.com', 'password'))
        .thenAnswer((_) async => null);

    // Build RegisterScreen widget with the mocked AuthService
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // Enter text into the email and password fields
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap the register button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget after the state change

    // Verify that signUpWithEmail was called
    verify(mockAuthService.signUpWithEmail('test@example.com', 'password'))
        .called(1);

    // Verify that SnackBar is shown on failed registration
    expect(find.text('Failed to register'), findsOneWidget);
  });
}
