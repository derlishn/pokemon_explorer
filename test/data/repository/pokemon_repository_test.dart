import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/network/api_client.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/core/error/failure.dart';
import 'package:pokemon_explorer/core/network/network_exceptions.dart';
import 'package:pokemon_explorer/core/constants/api_keys.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockStorageService extends Mock implements StorageService {}

class MockSettingsService extends Mock implements SettingsService {
  @override
  InternalFinalCallback<void> get onStart =>
      InternalFinalCallback<void>(callback: () {});
  @override
  InternalFinalCallback<void> get onDelete =>
      InternalFinalCallback<void>(callback: () {});
}

void main() {
  late PokemonRepository repository;
  late MockApiClient mockApiClient;
  late MockStorageService mockStorage;
  late MockSettingsService mockSettings;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorage = MockStorageService();
    mockSettings = MockSettingsService();

    // Register mock SettingsService in Get
    Get.put<SettingsService>(mockSettings);

    repository = PokemonRepository(
      apiClient: mockApiClient,
      storageService: mockStorage,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('PokemonRepository Tests', () {
    const tPokemonName = 'pikachu';
    const tPokemonId = 25;

    final tPokemonListResponse = {
      ApiKeys.results: [
        {
          ApiKeys.name: tPokemonName,
          ApiKeys.url: 'https://pokeapi.co/api/v2/pokemon/$tPokemonId/',
        },
      ],
    };

    final tPokemonDetailResponse = {
      ApiKeys.id: tPokemonId,
      ApiKeys.name: tPokemonName,
      ApiKeys.height: 4,
      ApiKeys.weight: 60,
      ApiKeys.baseExperience: 112,
      ApiKeys.types: [
        {
          ApiKeys.type: {ApiKeys.name: 'electric'},
        },
      ],
      ApiKeys.stats: [
        {
          ApiKeys.baseStat: 35,
          ApiKeys.stat: {ApiKeys.name: 'hp'},
        },
      ],
      ApiKeys.abilities: [
        {
          ApiKeys.ability: {ApiKeys.name: 'static'},
          'is_hidden': false,
        },
      ],
    };

    group('getAllPokemon', () {
      test('should return list of pokemon when call is successful', () async {
        // arrange
        when(
          () => mockApiClient.safeGet(any(), query: any(named: 'query')),
        ).thenAnswer(
          (_) async => Response(body: tPokemonListResponse, statusCode: 200),
        );

        // act
        final result = await repository.getAllPokemon();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (list) => expect(list.first.name, tPokemonName),
        );
      });

      test('should return ServerFailure when api call fails', () async {
        // arrange
        when(
          () => mockApiClient.safeGet(any(), query: any(named: 'query')),
        ).thenThrow(FetchDataException('error', 500));

        // act
        final result = await repository.getAllPokemon();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should be Left'),
        );
      });
    });

    group('getPokemonDetail', () {
      test(
        'should return cached detail when available and cache is enabled',
        () async {
          // arrange
          when(() => mockSettings.useCache).thenReturn(true);
          when(
            () => mockStorage.read(any()),
          ).thenReturn(tPokemonDetailResponse);

          // act
          final result = await repository.getPokemonDetail(
            tPokemonId,
            name: tPokemonName,
          );

          // assert
          expect(result.isRight(), true);
          verify(() => mockStorage.read(any())).called(1);
          verifyNever(() => mockApiClient.safeGet(any()));
        },
      );

      test(
        'should fetch from network and save to cache when not in cache',
        () async {
          // arrange
          when(() => mockSettings.useCache).thenReturn(true);
          when(() => mockStorage.read(any())).thenReturn(null);
          when(() => mockApiClient.safeGet(any())).thenAnswer(
            (_) async =>
                Response(body: tPokemonDetailResponse, statusCode: 200),
          );
          when(
            () => mockStorage.write(any(), any()),
          ).thenAnswer((_) async => {});

          // act
          final result = await repository.getPokemonDetail(
            tPokemonId,
            name: tPokemonName,
          );

          // assert
          expect(result.isRight(), true);
          verify(() => mockApiClient.safeGet(any())).called(1);
          verify(() => mockStorage.write(any(), any())).called(2);
        },
      );

      test('should not use cache when disabled in settings', () async {
        // arrange
        when(() => mockSettings.useCache).thenReturn(false);
        when(() => mockApiClient.safeGet(any())).thenAnswer(
          (_) async => Response(body: tPokemonDetailResponse, statusCode: 200),
        );

        // act
        final result = await repository.getPokemonDetail(
          tPokemonId,
          name: tPokemonName,
        );

        // assert
        expect(result.isRight(), true);
        verifyNever(() => mockStorage.read(any()));
        verify(() => mockApiClient.safeGet(any())).called(1);
      });
    });
  });
}
