import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomPlaylist {
  final String id;
  final String name;
  final List<int> songIds;

  CustomPlaylist({required this.id, required this.name, required this.songIds});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'songIds': songIds,
      };

  factory CustomPlaylist.fromJson(Map<String, dynamic> json) => CustomPlaylist(
        id: json['id'],
        name: json['name'],
        songIds: List<int>.from(json['songIds']),
      );
}

class PlaylistsNotifier extends Notifier<List<CustomPlaylist>> {
  static const _key = 'custom_playlists';

  @override
  List<CustomPlaylist> build() {
    _loadPlaylists();
    return [];
  }

  Future<void> _loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    state = data.map((e) => CustomPlaylist.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  Future<void> createPlaylist(String name) async {
    final newPlaylist = CustomPlaylist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
    );
    state = [...state, newPlaylist];
    await _savePlaylists();
  }

  Future<void> addSongToPlaylist(String playlistId, int songId) async {
    state = state.map((p) {
      if (p.id == playlistId && !p.songIds.contains(songId)) {
        return CustomPlaylist(id: p.id, name: p.name, songIds: [...p.songIds, songId]);
      }
      return p;
    }).toList();
    await _savePlaylists();
  }
}

final playlistsProvider = NotifierProvider<PlaylistsNotifier, List<CustomPlaylist>>(() {
  return PlaylistsNotifier();
});
