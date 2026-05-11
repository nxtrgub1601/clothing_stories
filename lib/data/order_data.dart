import '../models/order.dart';
import '../models/cart_item.dart';

class OrderData {
  static List<Order> orders = [];

  static void addOrder(List<CartItem> items) {
    final total = items.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    orders.add(
      Order(
        items: List.from(items), // clone tránh bị thay đổi
        total: total,
        createdAt: DateTime.now(),
      ),
    );
  }
}