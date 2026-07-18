import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (e) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────
  // FETCH PRODUCTS
  // ─────────────────────────────────────────────────
  Future<List<Product>> fetchProducts({String? category}) async {
    try {
      final client = _supabase;
      if (client == null) {
        print('Supabase client is null. Falling back to mock products.');
        return _getMockProducts();
      }

      var query = client.from('products').select();

      if (category != null && category.toLowerCase() != 'all') {
        query = query.eq('category', category);
      }

      final response = await query.order('created_at', ascending: false);

      if (response == null || (response as List).isEmpty) {
        return _getMockProducts();
      }

      final data = response as List;
      return data.map((json) {
        var product = Product.fromJson(json as Map<String, dynamic>);
        if (product.imageUrl.startsWith('http://')) {
          return Product(
            id: product.id,
            name: product.name,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl.replaceFirst('http://', 'https://'),
            category: product.category,
            variant: product.variant,
            isFeatured: product.isFeatured,
            artisanName: product.artisanName,
            artisanAvatar: product.artisanAvatar,
            artisanProcess: product.artisanProcess,
          );
        }
        return product;
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return _getMockProducts();
    }
  }

  // ─────────────────────────────────────────────────
  // FETCH CATEGORIES
  // ─────────────────────────────────────────────────
  Future<List<String>> fetchCategories() async {
    try {
      final client = _supabase;
      if (client == null) {
        return ['All', 'Clothing', 'Accessories', 'Electronics', 'Wellness'];
      }

      final response = await client.from('categories').select('name');
      
      if (response == null || (response as List).isEmpty) {
        return ['All', 'Clothing', 'Accessories', 'Electronics', 'Wellness'];
      }

      final categories = (response as List).map((data) => data['name'] as String).toList();
      if (!categories.contains('All')) {
        categories.insert(0, 'All');
      }
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return ['All', 'Clothing', 'Accessories', 'Electronics', 'Wellness'];
    }
  }

  // ─────────────────────────────────────────────────
  // MOCK DATA (FALLBACK)
  // ─────────────────────────────────────────────────
  List<Product> _getMockProducts() {
    return [
      Product(
        id: 'mock-1',
        name: 'Essential Cotton T-Shirt',
        description: 'Premium minimalist cotton t-shirt for daily comfort.',
        price: 799,
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
        category: 'Clothing',
        variant: 'Organic Cotton',
      ),
      Product(
        id: 'mock-2',
        name: 'Classic Wrist Watch',
        description: 'Timeless analog watch with a minimalist dial.',
        price: 2499,
        imageUrl: 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3',
        category: 'Accessories',
        variant: 'Silver Mesh',
      ),
      Product(
        id: 'mock-3',
        name: 'Wireless Earbuds',
        description: 'High-fidelity audio with active noise cancellation.',
        price: 2999,
        imageUrl: 'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5',
        category: 'Electronics',
        variant: 'Pearl White',
      ),
      Product(
        id: 'mock-4',
        name: 'Running Shoes',
        description: 'Engineered for distance and joint protection.',
        price: 2999,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        category: 'Wellness',
        variant: 'Aero Mesh',
      ),
    ];
  }
}
