import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:flutter/material.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late SettingsService settingsService;
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    
    // Default mock behavior for initialization
    when(() => mockStorage.read<String>(any())).thenReturn(null);
    when(() => mockStorage.read<int>(any())).thenReturn(null);
    when(() => mockStorage.read<bool>(any())).thenReturn(null);
    
    settingsService = SettingsService(storageService: mockStorage);
  });

  group('SettingsService Tests', () {
    test('Initial theme mode should be light when no preference is saved', () {
      expect(settingsService.themeMode, ThemeMode.light);
    });

    test('Initial accent color should be default neutral', () {
      expect(settingsService.accentColor.toARGB32(), Colors.grey.toARGB32());
    });

    test('updateAccentColor should change the color and persist it', () async {
      const newColor = Colors.red;
      
      // Mock the write behavior
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});
      
      settingsService.updateAccentColor(newColor);
      
      expect(settingsService.accentColor.toARGB32(), newColor.toARGB32());
      verify(() => mockStorage.write(any(), any())).called(1);
    });
  });
}
