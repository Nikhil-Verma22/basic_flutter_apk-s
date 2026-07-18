import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme.dart';
import '../widgets/mini_player.dart';
import 'music_player_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          songsAsync.when(
            data: (songs) {
              final favoriteSongs = songs.where((song) => favorites.contains(song.id)).toList();
              
              if (favoriteSongs.isEmpty) {
                return const Center(child: Text("No favorites yet."));
              }
              
              return ListView.separated(
                padding: EdgeInsets.only(bottom: 160 + MediaQuery.of(context).padding.bottom, top: 16),
                itemCount: favoriteSongs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final song = favoriteSongs[index];
                  final isPlaying = ref.watch(currentSongProvider)?.id == song.id;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isPlaying ? BeatsTheme.surfaceContainerLow : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(12),
                        nullArtworkWidget: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: BeatsTheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.music_note, color: BeatsTheme.onSurfaceVariant),
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                          color: isPlaying ? BeatsTheme.primary : BeatsTheme.onSurface,
                          fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist ?? 'Unknown Artist',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: BeatsTheme.onSurfaceVariant),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: BeatsTheme.primary),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(song.id);
                        },
                      ),
                      onTap: () {
                        ref.read(playlistProvider.notifier).loadAndPlay(favoriteSongs, index);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MusicPlayerScreen()),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: BeatsTheme.primary)),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          // MiniPlayer now in MainTabScreen
        ],
      ),
    );
  }
}
