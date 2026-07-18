import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/keys.dart';

class SharedFloatingNavBar extends StatelessWidget {
  final int activeIndex;

  const SharedFloatingNavBar({super.key, this.activeIndex = -1});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFDCE5E0).withOpacity(0.85),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(context, Icons.home_filled, activeIndex == 0, () {
                if (activeIndex != 0) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
                homeKey.currentState?.scrollToTop();
              }),
              _buildNavIcon(context, Icons.search, activeIndex == 1, () {
                if (activeIndex != 0) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
                homeKey.currentState?.focusSearch();
              }),
              _buildCartIcon(context, activeIndex == 2),
              _buildNavIcon(context, Icons.person_outline, activeIndex == 3, () {
                if (activeIndex != 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, bool isActive, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Theme.of(context).colorScheme.onSurface : const Color(0xFF58615E),
        size: 28,
      ),
      onPressed: onTap,
    );
  }

  Widget _buildCartIcon(BuildContext context, bool isActive) {
    return Consumer<CartProvider>(
      builder: (_, cart, __) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildNavIcon(context, Icons.shopping_bag_outlined, isActive, () {
              if (!isActive) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              }
            }),
            if (cart.itemCount > 0)
              Positioned(
                right: 2,
                top: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A615A),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${cart.itemCount}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
