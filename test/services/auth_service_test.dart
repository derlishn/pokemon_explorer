import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/features/auth/data/repositories/auth_repository.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;
  late MockAuthRepository mockAuthRepo;
  late MockStorageService mockStorage;

  setUp(() {
    Get.testMode = true;
    mockAuthRepo = MockAuthRepository();
    mockStorage = MockStorageService();

    authService = AuthService(
      authRepository: mockAuthRepo,
      storageService: mockStorage,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthService Tests', () {
    test('init should load state from storage', () async {
      // arrange
      when(() => mockStorage.read<bool>(AppConstants.keyIsLoggedIn)).thenReturn(true);
      when(() => mockAuthRepo.getSavedUsername()).thenAnswer((_) async => const Right('flutter'));

      // act
      await authService.init();

      // assert
      expect(authService.isLoggedIn.value, true);
      expect(authService.userName.value, 'flutter');
    });

    test('login should update state and persist', () async {
      // arrange
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});
      when(() => mockAuthRepo.saveCredentials(any(), any())).thenAnswer((_) async => const Right(unit));

      // act
      await authService.login('user', 'pass');

      // assert
      expect(authService.isLoggedIn.value, true);
      expect(authService.userName.value, 'user');
      verify(() => mockStorage.write(AppConstants.keyIsLoggedIn, true)).called(1);
      verify(() => mockAuthRepo.saveCredentials('user', 'pass')).called(1);
    });

    test('logout should clear state and storage', () async {
      // arrange
      authService.isLoggedIn.value = true;
      when(() => mockStorage.remove(any())).thenAnswer((_) async => {});
      when(() => mockAuthRepo.clearSession()).thenAnswer((_) async => const Right(unit));

      // act
      await authService.logout();

      // assert
      expect(authService.isLoggedIn.value, false);
      expect(authService.userName.value, AppConstants.defaultUserName);
      verify(() => mockStorage.remove(AppConstants.keyIsLoggedIn)).called(1);
      verify(() => mockAuthRepo.clearSession()).called(1);
    });
  });
}
