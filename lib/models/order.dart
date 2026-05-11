import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  Order({
    required this.items,
    required this.total,
    required this.createdAt,
  });
}