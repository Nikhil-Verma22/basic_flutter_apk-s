import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

final audioQueryProvider = Provider((ref) => OnAudioQuery());

final audioPlayerProvider = Provider((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final permissionProvider = FutureProvider<bool>((ref) async {
  var status = await Permission.audio.status;
  if (!status.isGranted) {
    status = await Permission.audio.request();
  }
  if (!status.isGranted) {
    // For older Android versions
    var storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }
  return status.isGranted;
});

final songsProvider = FutureProvider<List<SongModel>>((ref) async {
  final hasPermission = await ref.watch(permissionProvider.future);
  if (!hasPermission) return [];
  
  final audioQuery = ref.read(audioQueryProvider);
  return audioQuery.querySongs(
    sortType: null,
    orderType: OrderType.ASC_OR_SMALLER,
    uriType: UriType.EXTERNAL,
    ignoreCase: true,
  );
});

final playlistProvider = NotifierProvider<PlaylistNotifier, List<SongModel>>(() {
  return PlaylistNotifier();
});

class PlaylistNotifier extends Notifier<List<SongModel>> {
  ConcatenatingAudioSource? _playlist;

  @override
  List<SongModel> build() => [];

  Future<void> loadAndPlay(List<SongModel> songs, int initialIndex) async {
    state = songs;
    final player = ref.read(audioPlayerProvider);
    
    final audioSources = songs.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          album: song.album ?? 'Unknown Album',
          title: song.title,
          artist: song.artist ?? 'Unknown Artist',
          artUri: Uri.parse('content://media/external/audio/albumart/${song.albumId}'),
        ),
      );
    }).toList();
    
    _playlist = ConcatenatingAudioSource(children: audioSources);
    await player.setAudioSource(_playlist!, initialIndex: initialIndex, initialPosition: Duration.zero);
    await player.play();
  }
  
  void skipToNext() {
    ref.read(audioPlayerProvider).seekToNext();
  }
  
  void skipToPrevious() {
    ref.read(audioPlayerProvider).seekToPrevious();
  }
  
  void togglePlayPause() {
    final player = ref.read(audioPlayerProvider);
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void toggleShuffle() async {
    final player = ref.read(audioPlayerProvider);
    final enable = !player.shuffleModeEnabled;
    await player.setShuffleModeEnabled(enable);
  }

  void toggleLoop() async {
    final player = ref.read(audioPlayerProvider);
    switch (player.loopMode) {
      case LoopMode.off:
        await player.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        await player.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        await player.setLoopMode(LoopMode.off);
        break;
    }
  }
}

final currentSongProvider = Provider<SongModel?>((ref) {
  final currentSequence = ref.watch(sequenceStateProvider).value;
  final songs = ref.watch(playlistProvider);
  
  if (currentSequence == null || songs.isEmpty) return null;
  
  final int? index = currentSequence.currentIndex;
  if (index != null && index >= 0 && index < songs.length) {
    return songs[index];
  }
  return null;
});

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(audioPlayerProvider).playerStateStream;
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(audioPlayerProvider).positionStream;
});

final durationProvider = StreamProvider<Duration?>((ref) {
  return ref.watch(audioPlayerProvider).durationStream;
});

final sequenceStateProvider = StreamProvider<SequenceState?>((ref) {
  return ref.watch(audioPlayerProvider).sequenceStateStream;
});

final shuffleModeEnabledProvider = StreamProvider<bool>((ref) {
  return ref.watch(audioPlayerProvider).shuffleModeEnabledStream;
});

final loopModeProvider = StreamProvider<LoopMode>((ref) {
  return ref.watch(audioPlayerProvider).loopModeStream;
});
