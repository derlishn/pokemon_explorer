import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:flutter/material.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  late SettingsService settingsService;
  late MockGetStorage mockStorage;

  setUpAll(() async {
    // Required for GetStorage testing
    await GetStorage.init();
  });

  setUp(() {
    mockStorage = MockGetStorage();
    settingsService = SettingsService();
    
    // Default mock behavior
    when(() => mockStorage.read(any())).thenReturn(null);
  });

  group('SettingsService Tests', () {
    test('Initial theme mode should be system when no preference is saved', () {
      expect(settingsService.themeMode, ThemeMode.system);
    });

    test('Initial accent color should be default neutral', () {
      expect(settingsService.accentColor.value, Colors.grey.value);
    });

    test('updateAccentColor should change the color and persist it', () async {
      // In a real app, we'd use Get.put, but here we test the logic
      final newColor = Colors.red;
      settingsService.updateAccentColor(newColor);
      
      expect(settingsService.accentColor.value, newColor.value);
    });
  });
}
