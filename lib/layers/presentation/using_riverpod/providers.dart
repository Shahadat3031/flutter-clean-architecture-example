import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/repository/character_repository.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/list_page/notifier/character_page_state.dart';
import 'package:rickmorty/layers/presentation/using_riverpod/list_page/notifier/character_state_notifier.dart';
import 'package:rickmorty/main.dart';

// -----------------------------------------------------------------------------
// Presentation
// -----------------------------------------------------------------------------
final characterPageStateProvider =
    StateNotifierProvider<CharacterStateNotifier, CharacterPageState>(
  (ref) => CharacterStateNotifier(
    getAllCharacters: ref.read(getAllCharactersProvider),
  ),
);

// -----------------------------------------------------------------------------
// Domain
// -----------------------------------------------------------------------------
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepositoryImpl(
    api: ref.read(apiProvider),
    localStorage: ref.read(localStorageProvider),
  ),
);

final getAllCharactersProvider = Provider(
  (ref) => GetAllCharacters(
    repository: ref.read(characterRepositoryProvider),
  ),
);

// -----------------------------------------------------------------------------
// Data
// -----------------------------------------------------------------------------
final apiProvider = Provider<Api>((ref) => ApiImpl());

final localStorageProvider = Provider<LocalStorage>(
  (ref) => LocalStorageImpl(sharedPreferences: sharedPref),
);
