class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? variant;
  final bool isFeatured;
  final String? artisanName;
  final String? artisanAvatar;
  final String? artisanProcess;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.variant,
    this.isFeatured = false,
    this.artisanName,
    this.artisanAvatar,
    this.artisanProcess,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] is String) ? json['id'] : json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: _parsePrice(json['price']),
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      variant: json['variant'],
      isFeatured: json['is_featured'] ?? false,
      artisanName: json['artisan_name'],
      artisanAvatar: json['artisan_avatar'],
      artisanProcess: json['artisan_process'],
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'variant': variant,
      'is_featured': isFeatured,
      'artisan_name': artisanName,
      'artisan_avatar': artisanAvatar,
      'artisan_process': artisanProcess,
    };
  }
}
