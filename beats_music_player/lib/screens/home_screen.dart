import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../providers/playlists_provider.dart';
import '../theme.dart';
import '../widgets/mini_player.dart';
import 'music_player_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beats',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          songsAsync.when(
            data: (songs) {
              if (songs.isEmpty) {
                return const Center(child: Text("No Music Found \nPlease ensure storage permissions are granted."));
              }
              return ListView.separated(
                padding: EdgeInsets.only(bottom: 160 + MediaQuery.of(context).padding.bottom, top: 16), // Space for mini player + nav
                itemCount: songs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8), 
                itemBuilder: (context, index) {
                  final song = songs[index];
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
                        icon: const Icon(Icons.playlist_add, color: BeatsTheme.onSurfaceVariant),
                        onPressed: () => _showAddToPlaylistSheet(context, ref, song.id),
                      ),
                      onTap: () {
                        ref.read(playlistProvider.notifier).loadAndPlay(songs, index);
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

  void _showAddToPlaylistSheet(BuildContext context, WidgetRef ref, int songId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BeatsTheme.surfaceContainerHigh,
      builder: (context) {
        final playlists = ref.watch(playlistsProvider);
        if (playlists.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text("No custom albums exist yet.", style: TextStyle(color: BeatsTheme.onSurface)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return ListTile(
              leading: const Icon(Icons.queue_music, color: BeatsTheme.primary),
              title: Text(playlist.name, style: const TextStyle(color: BeatsTheme.onSurface)),
              onTap: () {
                ref.read(playlistsProvider.notifier).addSongToPlaylist(playlist.id, songId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Album')),
                );
              },
            );
          },
        );
      },
    );
  }
}

