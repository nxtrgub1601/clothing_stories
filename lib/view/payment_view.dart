import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/cart_data.dart';
import '../models/cart_item.dart';
import 'order_success_view.dart';
import '../data/order_data.dart';

class PaymentView extends StatefulWidget {
  final List<CartItem> selectedItems; // 🔥 nhận dữ liệu

  const PaymentView({super.key, required this.selectedItems});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  int _selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    // 🔥 tính tổng tiền đúng
    final totalAmount = widget.selectedItems.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin đơn hàng
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin đơn hàng',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng tiền cần thanh toán:'),
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Chọn phương thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // COD
            Card(
              child: RadioListTile<int>(
                title: const Text('Thanh toán khi nhận hàng (COD)'),
                value: 0,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => _selectedPaymentMethod = value!);
                },
              ),
            ),

            const SizedBox(height: 12),

            // QR
            Card(
              child: RadioListTile<int>(
                title: const Text('Thanh toán bằng QR'),
                value: 1,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => _selectedPaymentMethod = value!);
                },
              ),
            ),

            const SizedBox(height: 30),

            // QR hiển thị
            if (_selectedPaymentMethod == 1) ...[
              const Center(
                child: Text(
                  'Quét mã QR để thanh toán',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data:
                  'ClothVN_${totalAmount.toStringAsFixed(0)}',
                  size: 250,
                ),
              ),
            ],

            const SizedBox(height: 40),

            // Nút thanh toán
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // 1. COPY dữ liệu trước khi bị xóa
                  final orderedItems = List<CartItem>.from(widget.selectedItems);

                  // 2. LƯU đơn hàng
                  OrderData.addOrder(orderedItems);

                  // 3. CHUYỂN màn + truyền dữ liệu
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderSuccessView(cartItems: orderedItems),
                    ),
                  );

                  // 4. XÓA sau cùng
                  CartData.removeSelected(widget.selectedItems);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _selectedPaymentMethod == 0
                      ? 'Xác nhận đặt hàng'
                      : 'Hoàn tất thanh toán QR',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}