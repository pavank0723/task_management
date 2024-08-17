import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management/utils/utils.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {
  @override
  final User user;

  MockUserCredential(this.user);
}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      authService = AuthService();
    });

    test('signUpWithEmail should return user on success', () async {
      // Mock the FirebaseAuth behavior
      when(mockUser.uid).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');

      final mockUserCredential = MockUserCredential(mockUser);

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signUpWithEmail('test@example.com', 'password');

      expect(result, isNotNull);
      expect(result?.email, 'test@example.com');
    });

    test('signUpWithEmail should return null on failure', () async {
      // Mock FirebaseAuth behavior for failure
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).thenThrow(FirebaseAuthException(message: 'Registration failed', code: ''));

      final result = await authService.signUpWithEmail('test@example.com', 'password');

      expect(result, isNull);
    });
  });
}
