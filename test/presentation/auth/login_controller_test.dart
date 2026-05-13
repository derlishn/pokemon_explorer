import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_controller.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  @override
  InternalFinalCallback<void> get onStart => InternalFinalCallback<void>(callback: () {});
  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback<void>(callback: () {});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LoginController controller;
  late MockAuthService mockAuthService;

  setUp(() {
    Get.testMode = true;
    mockAuthService = MockAuthService();
    Get.put<AuthService>(mockAuthService);
    
    controller = LoginController();
    controller.onInit();
  });

  tearDown(() {
    Get.reset();
  });

  group('LoginController Tests', () {
    test('form should be invalid initially', () {
      expect(controller.isFormValid.value, false);
    });

    test('form should be valid when fields have at least 4 chars', () {
      // act
      controller.userController.text = 'flutter';
      controller.passwordController.text = 'flutter';

      // assert
      expect(controller.isFormValid.value, true);
    });

    test('login should call AuthService when credentials are correct', () async {
      // arrange
      controller.userController.text = 'flutter';
      controller.passwordController.text = 'flutter';
      when(() => mockAuthService.login(any(), any())).thenAnswer((_) async => {});

      // act
      controller.login();

      // assert
      verify(() => mockAuthService.login('flutter', 'flutter')).called(1);
    });
  });
}
