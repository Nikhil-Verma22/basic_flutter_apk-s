import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/shared_nav_bar.dart';
import '../utils/keys.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Product> _allProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final service = SupabaseService();
    final products = await service.fetchProducts();
    final categories = await service.fetchCategories();
    if (mounted) {
      setState(() {
        _allProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty || product.name.toLowerCase().contains(query) || product.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void focusSearch() {
    scrollToTop();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 60)), // Breathing room

              // ── Top Title & Hero Section ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apni\nDukan.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -1.5,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ),

              // ── Filter Chips ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildFilterChips(),
                ),
              ),

              // ── Loading Indicator ──
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5A615A),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )

              // ── Empty Results ──
              else if (_filteredProducts.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())

              // ── Product Grid ──
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120), // Bottom padding for nav bar
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 32,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.58, // Taller for organic look
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: _filteredProducts[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: _filteredProducts[index],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                ),
            ],
          ),

          // ── Floating Navigation ──
          const Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: SharedFloatingNavBar(activeIndex: 0),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 56, // Thicker
      decoration: BoxDecoration(
        color: const Color(0xFFE9EFEB), // surface-container
        borderRadius: BorderRadius.circular(9999), // Pill
      ),
      child: TextField(
        focusNode: _searchFocusNode,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search collection...',
          hintStyle: TextStyle(
            fontSize: 16,
            color: const Color(0xFF9A9E9B),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(Icons.search, color: Color(0xFF9A9E9B), size: 22),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF9A9E9B), size: 20),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // FILTER CHIPS
  // ─────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final label = _categories[index];
          final isSelected = label == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).colorScheme.secondary : const Color(0xFFE3EAE6), // secondary vs surface-container-high
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                child: Text(
                  label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: 1.2,
                    color: isSelected ? Colors.white : const Color(0xFF58615E),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 52, color: Color(0xFFABB4B0)),
          const SizedBox(height: 24),
          Text(
            'No forms found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF58615E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Curate a different view.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF9A9E9B),
            ),
          ),
        ],
      ),
    );
  }
}
