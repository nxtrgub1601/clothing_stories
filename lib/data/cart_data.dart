import '../models/cart_item.dart';
import '../models/product.dart';

class CartData {
  static List<CartItem> items = [];

  // Thêm vào giỏ
  static void add(Product product) {
    final existing =
        items.where((item) => item.product.id == product.id).firstOrNull;
    if (existing != null) {
      existing.quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  // Xóa 1 sản phẩm
  static void remove(CartItem item) {
    items.remove(item);
  }

  // 🔥 XÓA NHIỀU SẢN PHẨM (MỚI)
  static void removeSelected(List<CartItem> selectedItems) {
    items.removeWhere((item) => selectedItems.contains(item));
  }

  // Giảm số lượng
  static void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      remove(item);
    }
  }

  // Tổng tiền
  static double getTotal() {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Tổng số lượng
  static int getTotalQuantity() {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}