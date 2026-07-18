import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../theme.dart';
import 'glass_container.dart';
import '../screens/music_player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final playerState = ref.watch(playerStateProvider).value;
    
    if (currentSong == null) return const SizedBox.shrink();
    
    final playing = playerState?.playing ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
      },
      child: GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        borderRadius: 9999, // Pill shape
        child: Row(
          children: [
            QueryArtworkWidget(
              id: currentSong.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(20),
              nullArtworkWidget: const CircleAvatar(
                backgroundColor: BeatsTheme.surfaceContainerHighest,
                radius: 24,
                child: Icon(Icons.music_note, color: BeatsTheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentSong.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    currentSong.artist ?? 'Unknown Artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BeatsTheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              color: BeatsTheme.primary,
              onPressed: () {
                ref.read(playlistProvider.notifier).togglePlayPause();
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              color: BeatsTheme.onSurface,
              onPressed: () {
                ref.read(playlistProvider.notifier).skipToNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}
