import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class OrderSuccessView extends StatelessWidget {
  final List<CartItem> cartItems;

  const OrderSuccessView({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Tính total từ chính dữ liệu truyền vào
    final totalAmount = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng thành công'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Đặt hàng thành công!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Cảm ơn bạn đã mua hàng tại ClothVN',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          Text('ClothVN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('HÓA ĐƠN BÁN HÀNG', style: TextStyle(fontSize: 16, letterSpacing: 2)),
                        ],
                      ),
                    ),
                    const Divider(height: 30),

                    const Text(
                      'Chi tiết đơn hàng:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ...cartItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${item.quantity} x ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${(item.product.price * item.quantity).toStringAsFixed(0)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng tiền thanh toán:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${totalAmount.toStringAsFixed(0)}đ',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      'Phương thức: Thanh toán khi nhận hàng (COD)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đang in hóa đơn...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('In hóa đơn'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}