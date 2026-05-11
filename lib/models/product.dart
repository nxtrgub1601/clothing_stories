class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageAsset;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final double rating;
  final int sold;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageAsset = '',
    this.imageUrl = '',
    required this.description,
    required this.sizes,
    this.rating = 4.5,
    this.sold = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageAsset: map['imageAsset'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      rating: (map['rating'] ?? 4.5).toDouble(),
      sold: map['sold'] ?? 0,
    );
  }
}