import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../theme.dart';
import 'music_player_screen.dart';

class AlbumSongsScreen extends ConsumerWidget {
  final String title;
  final List<SongModel> songs;
  final Widget artwork;

  const AlbumSongsScreen({
    super.key,
    required this.title,
    required this.songs,
    required this.artwork,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Header artwork
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: artwork,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: songs.isEmpty
                ? const Center(child: Text("No songs found in this album."))
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: 120 + MediaQuery.of(context).padding.bottom),
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
                          onTap: () {
                            ref.read(playlistProvider.notifier).loadAndPlay(songs, index);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const MusicPlayerScreen()),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
