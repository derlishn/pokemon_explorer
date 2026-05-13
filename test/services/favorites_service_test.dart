import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late FavoritesService favoritesService;
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    favoritesService = FavoritesService(storageService: mockStorage);
  });

  tearDown(() {
    Get.reset();
  });

  group('FavoritesService Tests', () {
    final tPokemon = PokemonListItemModel(
      name: 'pikachu', 
      url: 'https://pokeapi.co/api/v2/pokemon/25/'
    );

    test('toggleFavorite should add pokemon if not present', () async {
      // arrange
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});

      // act
      favoritesService.toggleFavorite(tPokemon);

      // assert
      expect(favoritesService.favorites.contains(tPokemon), true);
      verify(() => mockStorage.write(AppConstants.keyFavorites, any())).called(1);
    });

    test('toggleFavorite should remove pokemon if already present', () async {
      // arrange
      favoritesService.favorites.add(tPokemon);
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});

      // act
      favoritesService.toggleFavorite(tPokemon);

      // assert
      expect(favoritesService.favorites.contains(tPokemon), false);
      verify(() => mockStorage.write(AppConstants.keyFavorites, any())).called(1);
    });

    test('isFavorite should return correct state', () {
      // arrange
      favoritesService.favorites.add(tPokemon);

      // assert
      expect(favoritesService.isFavorite(25), true);
      expect(favoritesService.isFavorite(1), false);
    });
  });
}
