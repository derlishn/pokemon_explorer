import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/home_controller.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}
class MockSettingsService extends Mock implements SettingsService {
  @override
  InternalFinalCallback<void> get onStart => InternalFinalCallback<void>(callback: () {});
  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback<void>(callback: () {});
}

void main() {
  late HomeController controller;
  late MockPokemonRepository mockRepository;
  late MockSettingsService mockSettings;

  setUp(() {
    mockRepository = MockPokemonRepository();
    mockSettings = MockSettingsService();

    Get.put<SettingsService>(mockSettings);
    
    // Default mock behavior
    when(() => mockSettings.gridColumns).thenReturn(2);

    controller = Get.put(HomeController(repository: mockRepository));
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('initial state should be correct', () {
      expect(controller.searchQuery.value, '');
      expect(controller.isSearching.value, false);
      expect(controller.pagingController.nextPageKey, 0);
    });

    test('search query update should trigger refresh', () async {
      // arrange
      final tPokemonList = [
        PokemonListItemModel(name: 'pikachu', url: 'https://pokeapi.co/api/v2/pokemon/25/')
      ];
      
      when(() => mockRepository.getAllPokemon(limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => Right(tPokemonList));

      // act
      controller.search = 'pika';

      // assert
      expect(controller.searchQuery.value, 'pika');
      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 900));
      verify(() => mockRepository.getAllPokemon(limit: 100, offset: 0)).called(1);
    });
  });
}
