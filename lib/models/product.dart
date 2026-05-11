class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String imageAsset;
  final String description;
  final List<String> sizes;
  final double rating;
  final int sold;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl = '',
    required this.imageAsset,
    required this.description,
    required this.sizes,
    this.rating = 4.5,
    this.sold = 0,
  });
}