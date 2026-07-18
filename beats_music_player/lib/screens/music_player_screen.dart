import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../theme.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final playerState = ref.watch(playerStateProvider).value;
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;
    final isShuffle = ref.watch(shuffleModeEnabledProvider).value ?? false;
    final loopMode = ref.watch(loopModeProvider).value ?? LoopMode.off;
    final favorites = ref.watch(favoritesProvider);
    
    if (currentSong == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text("No song playing")),
      );
    }
    
    final playing = playerState?.playing ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "NOW PLAYING",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
        ),
        centerTitle: true,
        actions: [
          if (currentSong != null)
            IconButton(
              icon: Icon(
                favorites.contains(currentSong.id) ? Icons.favorite : Icons.favorite_border,
                color: favorites.contains(currentSong.id) ? BeatsTheme.primary : BeatsTheme.onSurfaceVariant,
              ),
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(currentSong.id);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'album_art_${currentSong.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48), // MAX rounding pattern
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: QueryArtworkWidget(
                      id: currentSong.id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: double.infinity,
                      artworkHeight: double.infinity,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        color: BeatsTheme.surfaceContainerHigh,
                        child: const Center(
                          child: Icon(Icons.music_note, size: 100, color: BeatsTheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentSong.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentSong.artist ?? 'Unknown Artist',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: BeatsTheme.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const Spacer(),
              
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  activeTrackColor: BeatsTheme.primary,
                  inactiveTrackColor: BeatsTheme.surfaceContainerHighest,
                  thumbColor: BeatsTheme.primary,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                  value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0),
                  onChanged: (value) {
                    ref.read(audioPlayerProvider).seek(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(position), style: Theme.of(context).textTheme.labelSmall),
                    Text(_formatDuration(duration), style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.shuffle),
                    color: isShuffle ? BeatsTheme.primary : BeatsTheme.onSurfaceVariant,
                    onPressed: () => ref.read(playlistProvider.notifier).toggleShuffle(),
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.skip_previous),
                    color: BeatsTheme.onSurface,
                    onPressed: () => ref.read(playlistProvider.notifier).skipToPrevious(),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [BeatsTheme.primary, BeatsTheme.primaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33ff5167),
                          blurRadius: 20,
                        ) // Ambient Shadow
                      ],
                    ),
                    child: IconButton(
                      iconSize: 40,
                      color: BeatsTheme.surface, // very dark surface
                      icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                      onPressed: () => ref.read(playlistProvider.notifier).togglePlayPause(),
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.skip_next),
                    color: BeatsTheme.onSurface,
                    onPressed: () => ref.read(playlistProvider.notifier).skipToNext(),
                  ),
                  IconButton(
                    iconSize: 28,
                    icon: Icon(
                      loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                    ),
                    color: loopMode != LoopMode.off ? BeatsTheme.primary : BeatsTheme.onSurfaceVariant,
                    onPressed: () => ref.read(playlistProvider.notifier).toggleLoop(),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
