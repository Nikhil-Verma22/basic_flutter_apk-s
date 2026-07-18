import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/shared_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, size: 24, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE5E0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'A', // Default user initial
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5A615A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Apni Dukan Guest',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Email
                Text(
                  'guest@apnidukan.com',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF58615E),
                  ),
                ),
                const SizedBox(height: 48),

                // Options List
                _buildOptionRow(context, Icons.inventory_2_outlined, 'My Orders'),
                const SizedBox(height: 16),
                _buildOptionRow(context, Icons.favorite_border, 'Wishlist'),
                const SizedBox(height: 16),
                _buildOptionRow(context, Icons.location_on_outlined, 'Saved Addresses'),
                const SizedBox(height: 16),
                _buildOptionRow(context, Icons.settings_outlined, 'Settings'),
                const SizedBox(height: 40),

                // Logout button
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout functionality coming soon.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F5F1), // Gentle background
                    foregroundColor: const Color(0xFFA83836), // Error/Red color for layout
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: Text(
                    'LOG OUT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 100), // padding for nav bar
              ],
            ),
          ),
          
          // Shared Nav Bar at bottom
          const Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: SharedFloatingNavBar(activeIndex: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5A615A), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFABB4B0), size: 24),
        ],
      ),
    );
  }
}
