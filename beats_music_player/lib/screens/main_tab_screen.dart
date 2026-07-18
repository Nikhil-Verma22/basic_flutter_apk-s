import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/mini_player.dart';
import 'albums_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class TabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  
  void setIndex(int index) {
    state = index;
  }
}

final tabIndexProvider = NotifierProvider<TabIndexNotifier, int>(() => TabIndexNotifier());

class MainTabScreen extends ConsumerWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabIndexProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: const [
              HomeScreen(),
              SearchScreen(),
              AlbumsScreen(),
              FavoritesScreen(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPadding + 80 + 24, // Above NavBar
            child: const MiniPlayer(),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: (bottomPadding > 0 ? bottomPadding : 16) + 16,
            child: GlassContainer(
              borderRadius: 36,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Icons.album_outlined,
                    isSelected: currentIndex == 0,
                    onTap: () => ref.read(tabIndexProvider.notifier).setIndex(0),
                  ),
                  _NavBarItem(
                    icon: Icons.search,
                    isSelected: currentIndex == 1,
                    onTap: () => ref.read(tabIndexProvider.notifier).setIndex(1),
                  ),
                  _NavBarItem(
                    icon: Icons.library_music_outlined,
                    isSelected: currentIndex == 2,
                    onTap: () => ref.read(tabIndexProvider.notifier).setIndex(2),
                  ),
                  _NavBarItem(
                    icon: Icons.favorite_border,
                    isSelected: currentIndex == 3,
                    onTap: () => ref.read(tabIndexProvider.notifier).setIndex(3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? BeatsTheme.primary : BeatsTheme.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
