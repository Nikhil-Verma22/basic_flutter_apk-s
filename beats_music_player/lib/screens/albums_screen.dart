import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers/audio_provider.dart';
import '../providers/playlists_provider.dart';
import '../theme.dart';
import 'album_songs_screen.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePlaylistDialog(context, ref),
            tooltip: "Create Custom Album",
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (playlists.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text("Custom Albums", style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
          if (playlists.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: playlists.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return GestureDetector(
                      onTap: () => _openPlaylist(context, ref, playlist),
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: BeatsTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                  gradient: LinearGradient(
                                    colors: [BeatsTheme.primary, BeatsTheme.primaryContainer],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(Icons.queue_music, size: 50, color: BeatsTheme.surface),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    playlist.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: BeatsTheme.onSurface),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${playlist.songIds.length} songs",
                                    style: const TextStyle(color: BeatsTheme.onSurfaceVariant, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Device Albums", style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          
          FutureBuilder<List<AlbumModel>>(
            future: OnAudioQuery().queryAlbums(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: BeatsTheme.primary)),
                );
              }
              final albums = snapshot.data ?? [];
              if (albums.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No Albums Found"),
                  )),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 120 + MediaQuery.of(context).padding.bottom),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final album = albums[index];
                      // Group unknown albums
                      final albumName = (album.album == "<unknown>" || album.album.isEmpty) ? "Unknown" : album.album;

                      return GestureDetector(
                        onTap: () => _openDeviceAlbum(context, ref, album, albumName),
                        child: Container(
                          decoration: BoxDecoration(
                            color: BeatsTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  child: QueryArtworkWidget(
                                    id: album.id,
                                    type: ArtworkType.ALBUM,
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      color: BeatsTheme.surfaceContainerHigh,
                                      child: const Icon(Icons.album, size: 60, color: BeatsTheme.onSurfaceVariant),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      albumName,
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: BeatsTheme.onSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      album.artist ?? 'Unknown Artist',
                                      style: const TextStyle(color: BeatsTheme.onSurfaceVariant, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: albums.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showCreatePlaylistDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: BeatsTheme.surfaceContainerHigh,
          title: const Text("Create Custom Album", style: TextStyle(color: BeatsTheme.onSurface)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: BeatsTheme.onSurface),
            decoration: const InputDecoration(
              hintText: "E.g., Workout, Romance",
              hintStyle: TextStyle(color: BeatsTheme.onSurfaceVariant),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BeatsTheme.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: BeatsTheme.onSurfaceVariant)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: BeatsTheme.primary),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(playlistsProvider.notifier).createPlaylist(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Create", style: TextStyle(color: BeatsTheme.surface)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPlaylist(BuildContext context, WidgetRef ref, CustomPlaylist playlist) async {
    // we need to fetch the real SongModels that match the IDs
    final allSongs = await ref.read(songsProvider.future);
    final playlistSongs = allSongs.where((s) => playlist.songIds.contains(s.id)).toList();

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumSongsScreen(
          title: playlist.name,
          songs: playlistSongs,
          artwork: Container(
            color: BeatsTheme.primaryContainer,
            child: const Icon(Icons.queue_music, size: 80, color: BeatsTheme.primary),
          ),
        ),
      ),
    );
  }

  Future<void> _openDeviceAlbum(BuildContext context, WidgetRef ref, AlbumModel album, String title) async {
    final albumSongs = await ref.read(audioQueryProvider).queryAudiosFrom(AudiosFromType.ALBUM_ID, album.id);
    
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumSongsScreen(
          title: title,
          songs: albumSongs,
          artwork: QueryArtworkWidget(
            id: album.id,
            type: ArtworkType.ALBUM,
            artworkFit: BoxFit.cover,
            nullArtworkWidget: Container(
              color: BeatsTheme.surfaceContainerHigh,
              child: const Icon(Icons.album, size: 80, color: BeatsTheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}
