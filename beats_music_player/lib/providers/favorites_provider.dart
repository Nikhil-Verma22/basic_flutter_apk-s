import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    _loadFavorites();
    return {};
  }

  Future<void> _loadFavorites() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final favList = prefs.getStringList('favorites') ?? [];
    state = favList.map((id) => int.parse(id)).toSet();
  }

  Future<void> toggleFavorite(int id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final Set<int> newState = Set.from(state);

    if (newState.contains(id)) {
      newState.remove(id);
    } else {
      newState.add(id);
    }

    state = newState;
    await prefs.setStringList('favorites', newState.map((e) => e.toString()).toList());
  }

  bool isFavorite(int id) {
    return state.contains(id);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(() {
  return FavoritesNotifier();
});
