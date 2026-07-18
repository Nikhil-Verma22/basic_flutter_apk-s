import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../widgets/shared_nav_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Bag',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyState(context);
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      // ── Cart Items ──
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Divider(color: Color(0xFFE3EAE6), height: 1),
                        ),
                        itemBuilder: (context, index) {
                          final cartItem = cart.items[index];
                          return CartItemWidget(cartItem: cartItem, cart: cart);
                        },
                      ),

                      const SizedBox(height: 48),

                      // ── Order Summary ──
                      _buildOrderSummary(context, cart),

                      const SizedBox(height: 120), // Height for nav bar
                    ],
                  ),
                ),
              ),

              // ── Floating Navigation ──
              const Positioned(
                left: 24,
                right: 24,
                bottom: 32,
                child: SharedFloatingNavBar(activeIndex: 2),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // ORDER SUMMARY
  // ─────────────────────────────────────────────────
  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order Note',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _summaryRow('Subtotal', '₹${cart.subtotal.toInt()}'),
          const SizedBox(height: 12),
          _summaryRow('Shipping', cart.shipping == 0 ? 'Complimentary' : '₹${cart.shipping.toInt()}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFDCE5E0), height: 1),
          ),
          _summaryRow('Total', '₹${cart.total.toInt()}', isTotal: true),
          
          const SizedBox(height: 32),
          
          // Checkout CTA
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Checkout processing...'),
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: Text(
              'CHECKOUT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? const Color(0xFF2C3431) : const Color(0xFF58615E),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: const Color(0xFF2C3431),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 64, color: Color(0xFFABB4B0)),
              const SizedBox(height: 24),
              Text(
                'Your bag is empty',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF58615E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Curate your selection.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: const Color(0xFF9A9E9B),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCE5E0),
                  foregroundColor: const Color(0xFF2C3431),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Text(
                  'BROWSE COLLECTION',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Navigation bar visible even on empty state
        const Positioned(
          left: 24,
          right: 24,
          bottom: 32,
          child: SharedFloatingNavBar(activeIndex: 2),
        ),
      ],
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final CartProvider cart;

  const CartItemWidget({super.key, required this.cartItem, required this.cart});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : const Color(0xFFF0F5F1).withOpacity(0.5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isActive ? Colors.black : Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image WITH padding for frame
              Container(
                width: 88,
                height: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedScale(
                  scale: isActive ? 1.07 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.cartItem.product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Color(0xFF5A615A), strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, color: Color(0xFFABB4B0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.product.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.cartItem.product.variant != null)
                      Text(
                        widget.cartItem.product.variant!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: isActive ? Colors.white.withOpacity(0.7) : const Color(0xFF9A9E9B),
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    // Quantity controls
                    Row(
                      children: [
                        _buildQtyBtn(Icons.remove, isActive, () {
                          widget.cart.updateQuantity(widget.cartItem.product.id, widget.cartItem.quantity - 1);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${widget.cartItem.quantity}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        _buildQtyBtn(Icons.add, isActive, () {
                          widget.cart.updateQuantity(widget.cartItem.product.id, widget.cartItem.quantity + 1);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Price & Delete
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${(widget.cartItem.product.price * widget.cartItem.quantity).toInt()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () => widget.cart.removeFromCart(widget.cartItem.product.id),
                    child: Text(
                      'Remove',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white.withOpacity(0.6) : const Color(0xFF9A9E9B),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isActive ? Colors.white.withOpacity(0.2) : const Color(0xFFE3EAE6)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: isActive ? Colors.white : const Color(0xFF58615E)),
      ),
    );
  }
}
